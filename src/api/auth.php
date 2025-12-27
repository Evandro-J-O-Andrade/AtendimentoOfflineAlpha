<?php
require __DIR__ . '/config.php';

// CORS: permitir origem específica quando disponível e ativar credentials para cookies HttpOnly
$origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
if ($origin !== '*') {
    header("Access-Control-Allow-Origin: $origin");
    header('Access-Control-Allow-Credentials: true');
} else {
    header('Access-Control-Allow-Origin: *');
}
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['message' => 'Método não permitido']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

$login = $data['login'] ?? null;
$senha = $data['senha'] ?? null;

if (!$login || !$senha) {
    http_response_code(400);
    echo json_encode(['message' => 'Login e senha obrigatórios']);
    exit;
}

$pdo = getPDO();

/* ============================
   BUSCAR USUÁRIO
============================ */
$stmt = $pdo->prepare("
    SELECT 
        u.id_usuario,
        u.login,
        u.senha_hash,
        u.seed_password,
        p.nome_completo
    FROM usuario u
    JOIN pessoa p ON p.id_pessoa = u.id_pessoa
    WHERE u.login = ?
      AND u.ativo = 1
    LIMIT 1
");
$stmt->execute([$login]);
$usuario = $stmt->fetch();

if (!$usuario) {
    http_response_code(401);
    echo json_encode(['message' => 'Usuário ou senha inválidos']);
    exit;
}

/* ============================
   VALIDAR SENHA (com fallback de seed_password para ambiente de dev)
============================ */
$valid = false;
if (!empty($usuario['senha_hash']) && password_verify($senha, $usuario['senha_hash'])) {
    $valid = true;
} else if (!empty($usuario['seed_password']) && $senha === $usuario['seed_password']) {
    // primeiro login com senha seed: converte para hash e limpa seed_password
    $novo_hash = password_hash($senha, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare('UPDATE usuario SET senha_hash = ?, seed_password = NULL WHERE id_usuario = ?');
    $stmt->execute([$novo_hash, $usuario['id_usuario']]);

    // atualiza em memória
    $usuario['senha_hash'] = $novo_hash;
    $valid = true;
}

if (!$valid) {
    http_response_code(401);
    echo json_encode(['message' => 'Usuário ou senha inválidos']);
    exit;
}

/* ============================
   BUSCAR PERFIS
============================ */
$stmt = $pdo->prepare("
    SELECT p.nome
    FROM usuario_perfil up
    JOIN perfil p ON p.id_perfil = up.id_perfil
    WHERE up.id_usuario = ?
");
$stmt->execute([$usuario['id_usuario']]);
$perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

require_once __DIR__ . '/jwt.php';

/* ============================
   REFRESH TOKEN (rotacionável)
   - gera token aleatório, armazena hash (sha256) e expira em 30 dias
   - criamos o refresh ANTES do access token para incluir um "sid" no JWT
============================ */
$refresh_plain = null;
$expires_at = null;
$id_refresh = null;
try {
    $refresh_plain = bin2hex(random_bytes(64));
    $refresh_hash  = hash('sha256', $refresh_plain);
    $expires_at = date('Y-m-d H:i:s', time() + 30 * 24 * 3600);
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    $ip = $_SERVER['REMOTE_ADDR'] ?? null;

    $stmt = $pdo->prepare('INSERT INTO usuario_refresh (id_usuario, token_hash, expires_at, user_agent, ip) VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$usuario['id_usuario'], $refresh_hash, $expires_at, substr($user_agent, 0, 255), $ip]);
    $id_refresh = (int)$pdo->lastInsertId();
} catch (Exception $e) {
    // falha na geração/armazenamento do refresh token => log minimal e prosseguir sem refresh
    error_log('refresh token error: ' . $e->getMessage());
    $refresh_plain = null;
    $expires_at = null;
    $id_refresh = null;
}

/* ============================
   TOKEN JWT (HS256) - inclui sid quando disponível
============================ */
$payload = [
    'id_usuario' => $usuario['id_usuario'],
    'perfis' => $perfis
];
if (!empty($id_refresh)) {
    $payload['sid'] = $id_refresh;
}

$token = jwt_encode($payload, 3600);

/* ============================
   SUCESSO
============================ */
$response = [
    'token' => $token,
    'usuario' => [
        'id_usuario' => $usuario['id_usuario'],
        'login' => $usuario['login'],
        'nome' => $usuario['nome_completo'],
        'perfis' => $perfis
    ]
];

if ($refresh_plain) {
    // define cookie HttpOnly para refresh token (não acessível por JS)
    setcookie('refresh_token', $refresh_plain, [
        'expires' => time() + 30 * 24 * 3600,
        'path' => '/',
        'httponly' => true,
        'samesite' => 'Lax'
    ]);
    $response['refresh_set'] = true;
}

// Não retornamos o refresh_token no corpo por segurança
echo json_encode($response);
