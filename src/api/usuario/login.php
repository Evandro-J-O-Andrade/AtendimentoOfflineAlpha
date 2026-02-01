<?php
require __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$data = json_decode(file_get_contents('php://input'), true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "JSON inválido"]);
    exit;
}
$login = $data['login'] ?? '';
$senha = $data['senha'] ?? '';
if (empty($login) || empty($senha)) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "Login e senha são obrigatórios"]);
    exit;
}
try {
    $stmt = $pdo->prepare("SELECT u.id_usuario, u.senha_hash, p.nome_completo AS nome FROM usuario u JOIN pessoa p ON p.id_pessoa = u.id_pessoa WHERE u.login = ? AND u.ativo = 1");
    $stmt->execute([$login]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$user || !password_verify($senha, $user['senha_hash'])) {
        http_response_code(401);
        echo json_encode(["ok" => false, "error" => "Credenciais inválidas"]);
        exit;
    }
    $stmt = $pdo->prepare("SELECT DISTINCT p.nome AS perfil FROM usuario_perfil up JOIN perfil p ON p.id_perfil = up.id_perfil WHERE up.id_usuario = ? AND up.ativo = 1");
    $stmt->execute([$user['id_usuario']]);
    $perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);
    $token = hash('sha256', microtime() . $user['id_usuario'] . $login);
    unset($user['senha_hash']);
    echo json_encode(["ok" => true, "data" => ["token" => $token, "usuario" => ["id_usuario" => $user['id_usuario'], "login" => $login, "nome" => $user['nome'], "perfis" => $perfis]]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Erro ao fazer login: " . $e->getMessage()]);
}
