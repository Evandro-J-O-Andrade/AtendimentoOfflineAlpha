<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/jwt.php';

$data = json_decode(file_get_contents('php://input'), true);
$login = $data['login'] ?? '';
$senha = $data['senha'] ?? '';

if (!$login || !$senha) {
    http_response_code(400);
    echo json_encode(['message' => 'Login e senha obrigatórios']);
    exit;
}

$pdo = getPDO();
$stmt = $pdo->prepare("
    SELECT u.id_usuario, u.senha_hash, u.seed_password, p.nome_completo
    FROM usuario u
    JOIN pessoa p ON p.id_pessoa = u.id_pessoa
    WHERE u.login = ? AND u.ativo = 1
");
$stmt->execute([$login]);
$usuario = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$usuario) {
    http_response_code(401);
    echo json_encode(['message' => 'Usuário ou senha inválidos']);
    exit;
}

// validar senha
$valid = password_verify($senha, $usuario['senha_hash']) || ($usuario['seed_password'] && $senha === $usuario['seed_password']);
if (!$valid) {
    http_response_code(401);
    echo json_encode(['message' => 'Usuário ou senha inválidos']);
    exit;
}

// atualizar hash se usou seed_password
if ($usuario['seed_password'] && $senha === $usuario['seed_password']) {
    $novo_hash = password_hash($senha, PASSWORD_DEFAULT);
    $stmt = $pdo->prepare('UPDATE usuario SET senha_hash = ?, seed_password = NULL WHERE id_usuario = ?');
    $stmt->execute([$novo_hash, $usuario['id_usuario']]);
}

// buscar perfis
$stmt = $pdo->prepare("
    SELECT p.nome
    FROM usuario_perfil up
    JOIN perfil p ON p.id_perfil = up.id_perfil
    WHERE up.id_usuario = ?
");
$stmt->execute([$usuario['id_usuario']]);
$perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

// MASTER → ADMIN
if (in_array('MASTER', $perfis) && !in_array('ADMIN', $perfis)) {
    $perfis[] = 'ADMIN';
}

// gerar JWT
$token = jwt_encode([
    'id_usuario' => $usuario['id_usuario'],
    'perfis'     => $perfis
], 3600);

// retornar
echo json_encode([
    'token' => $token,
    'usuario' => [
        'id_usuario' => $usuario['id_usuario'],
        'login'      => $login,
        'nome'       => $usuario['nome_completo'],
        'perfis'     => $perfis
    ]
]);
