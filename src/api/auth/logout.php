<?php
// POST { "refresh_token": "..." }
require_once __DIR__ . '/../config.php';

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

// Lê refresh token do cookie HttpOnly
$refresh = $_COOKIE['refresh_token'] ?? null;
if (!$refresh) {
    // mesmo comportamento: retornar 200 para evitar info disclosure
    echo json_encode(["message" => "Logout realizado"]);
    exit;
}

$pdo = getPDO();
$refresh_hash = hash('sha256', $refresh);

$stmt = $pdo->prepare('UPDATE usuario_refresh SET revoked = 1 WHERE token_hash = ?');
$stmt->execute([$refresh_hash]);

// limpar cookie do lado do cliente (expirar)
setcookie('refresh_token', '', [
    'expires' => time() - 3600,
    'path' => '/',
    'httponly' => true,
    'samesite' => 'Lax'
]);

// sempre retorna 200 para evitar info disclosure
echo json_encode(["message" => "Logout realizado"]);
