<?php
require __DIR__ . '/config.php';
require_once __DIR__ . '/jwt.php';

header('Content-Type: application/json; charset=utf-8');

$data = json_decode(file_get_contents('php://input'), true);
$login = $data['login'] ?? null;
$senha = $data['senha'] ?? null;

if (!$login || !$senha) {
    http_response_code(400);
    echo json_encode(['message' => 'Login e senha obrigatórios']);
    exit;
}

$pdo = getPDO();

/* BUSCAR USUÁRIO */
$stmt = $pdo->prepare("
    SELECT 
        u.id_usuario,
        u.senha_hash,
        p.nome_completo
    FROM usuario u
    JOIN pessoa p ON p.id_pessoa = u.id_pessoa
    WHERE u.login = ? AND u.ativo = 1
    LIMIT 1
");
$stmt->execute([$login]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$usuario) {
    http_response_code(401);
    echo json_encode(['message' => 'Usuário ou senha inválidos']);
    exit;
}

/* VALIDAR SENHA */
if (!password_verify($senha, $usuario['senha_hash'])) {
    http_response_code(401);
    echo json_encode(['message' => 'Usuário ou senha inválidos']);
    exit;
}

/* BUSCAR PERFIS */
$stmt = $pdo->prepare("
    SELECT p.nome
    FROM usuario_perfil up
    JOIN perfil p ON p.id_perfil = up.id_perfil
    WHERE up.id_usuario = ?
");
$stmt->execute([$usuario['id_usuario']]);
$perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

if (!$perfis || count($perfis) === 0) {
    http_response_code(403);
    echo json_encode(['message' => 'Usuário sem perfil']);
    exit;
}

/* GERAR JWT */
$payload = [
    'id_usuario' => (int)$usuario['id_usuario'],
    'perfis' => $perfis
];
$token = jwt_encode($payload, 3600);

echo json_encode([
    'token' => $token,
    'usuario' => [
        'id_usuario' => (int)$usuario['id_usuario'],
        'nome' => $usuario['nome_completo'],
        'login' => $login,
        'perfis' => $perfis
    ]
]);
