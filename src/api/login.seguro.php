<?php
// login_seguro.php atualizado
require "config.php";

header("Content-Type: application/json; charset=UTF-8");

$data = json_decode(file_get_contents("php://input"), true);
$login = $data['login'] ?? '';
$senha_digitada = $data['senha'] ?? '';

if (empty($login) || empty($senha_digitada)) {
    http_response_code(400);
    echo json_encode(["erro" => "Login e senha são obrigatórios."]);
    exit;
}

// Pega dados do usuário
$stmt = $pdo->prepare("
    SELECT u.id_usuario, u.senha_hash, p.nome_completo AS nome
    FROM usuario u
    JOIN pessoa p ON p.id_pessoa = u.id_pessoa
    WHERE u.login = ? AND u.ativo = 1
");
$stmt->execute([$login]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(401);
    echo json_encode(["erro" => "Credenciais inválidas."]);
    exit;
}

// Valida senha
if (!password_verify($senha_digitada, $user['senha_hash'])) {
    http_response_code(401);
    echo json_encode(["erro" => "Credenciais inválidas."]);
    exit;
}

// Pega todos os perfis ativos do usuário nos sistemas
$stmt = $pdo->prepare("
    SELECT p.nome AS perfil
    FROM usuario_sistema us
    JOIN perfil p ON p.id_perfil = us.id_perfil
    WHERE us.id_usuario = ? AND us.ativo = 1
");
$stmt->execute([$user['id_usuario']]);
$perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

// Remove hash e retorna
unset($user['senha_hash']);

echo json_encode([
    "ok" => true,
    "token" => hash('sha256', microtime() . $user['id_usuario'] . $login),
    "usuario" => [
        "id_usuario" => $user['id_usuario'],
        "login" => $login,
        "nome" => $user['nome'],
        "perfis" => $perfis
    ]
]);
