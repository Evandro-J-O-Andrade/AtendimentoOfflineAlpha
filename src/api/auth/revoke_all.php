<?php
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../middleware.php';

// CORS + credentials
$origin = $_SERVER['HTTP_ORIGIN'] ?? '*';
if ($origin !== '*') {
    header("Access-Control-Allow-Origin: $origin");
    header('Access-Control-Allow-Credentials: true');
} else {
    header('Access-Control-Allow-Origin: *');
}
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Access-Control-Allow-Methods: POST, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(["message" => "Método não permitido"]);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$target_user = isset($data['user_id']) ? (int)$data['user_id'] : null;

$pdo = getPDO();
$usuario = validarToken($pdo);

if ($target_user && $target_user !== $usuario['id_usuario']) {
    // precisa ser admin
    if (!in_array('ADMIN', $usuario['perfis'])) {
        http_response_code(403);
        echo json_encode(["message" => "Acesso negado"]);
        exit;
    }
}

$uid = $target_user ?? $usuario['id_usuario'];

// revoga todas as sessões ativas do usuário
$stmt = $pdo->prepare('UPDATE usuario_refresh SET revoked = 1 WHERE id_usuario = ? AND revoked = 0');
$stmt->execute([$uid]);

// se for o próprio usuário, limpar cookie
if ($uid === $usuario['id_usuario']) {
    setcookie('refresh_token', '', [ 'expires' => time() - 3600, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax' ]);
}

echo json_encode(["message" => "Todas as sessões revogadas para o usuário"]);
