<?php
require __DIR__ . '/config.php';

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Methods: POST, OPTIONS');

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
   VALIDAR SENHA
============================ */
if (!password_verify($senha, $usuario['senha_hash'])) {
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

/* ============================
   TOKEN SIMPLES (FASE 1)
============================ */
$token = base64_encode(json_encode([
    'id_usuario' => $usuario['id_usuario'],
    'perfis' => $perfis,
    'exp' => time() + 3600
]));

/* ============================
   SUCESSO
============================ */
echo json_encode([
    'token' => $token,
    'usuario' => [
        'id_usuario' => $usuario['id_usuario'],
        'login' => $usuario['login'],
        'nome' => $usuario['nome_completo'],
        'perfis' => $perfis
    ]
]);
