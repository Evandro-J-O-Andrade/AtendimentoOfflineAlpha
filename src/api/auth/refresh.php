<?php
// POST { "refresh_token": "..." }
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../jwt.php';

// CORS + credentials for cookie-based refresh
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
    http_response_code(400);
    echo json_encode(["message" => "refresh_token (cookie) obrigatório"]);
    exit;
}

$pdo = getPDO();
$refresh_hash = hash('sha256', $refresh);

// localizar token válido
$stmt = $pdo->prepare("SELECT id_refresh, id_usuario FROM usuario_refresh WHERE token_hash = ? AND revoked = 0 AND expires_at >= NOW() LIMIT 1");
$stmt->execute([$refresh_hash]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) {
    http_response_code(401);
    echo json_encode(["message" => "Refresh token inválido ou expirado"]);
    exit;
}

$id_refresh = $row['id_refresh'];
$id_usuario = $row['id_usuario'];

$pdo->beginTransaction();
try {
    // marcar antigo como revogado
    $stmt = $pdo->prepare('UPDATE usuario_refresh SET revoked = 1 WHERE id_refresh = ?');
    $stmt->execute([$id_refresh]);

    // criar novo refresh
    $new_refresh = bin2hex(random_bytes(64));
    $new_hash = hash('sha256', $new_refresh);
    $expires_at = date('Y-m-d H:i:s', time() + 30 * 24 * 3600);
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    $ip = $_SERVER['REMOTE_ADDR'] ?? null;

    $stmt = $pdo->prepare('INSERT INTO usuario_refresh (id_usuario, token_hash, expires_at, user_agent, ip) VALUES (?, ?, ?, ?, ?)');
    $stmt->execute([$id_usuario, $new_hash, $expires_at, substr($user_agent, 0, 255), $ip]);
    $new_id = (int)$pdo->lastInsertId();

    // gerar novo access token (buscar perfis) e incluir sid do novo refresh
    $stmt = $pdo->prepare("SELECT p.nome FROM usuario_perfil up JOIN perfil p ON p.id_perfil = up.id_perfil WHERE up.id_usuario = ?");
    $stmt->execute([$id_usuario]);
    $perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

    $token = jwt_encode(['id_usuario' => $id_usuario, 'perfis' => $perfis, 'sid' => $new_id], 3600);

    $pdo->commit();

    // enviar novo refresh token como cookie HttpOnly
    setcookie('refresh_token', $new_refresh, [
        'expires' => time() + 30 * 24 * 3600,
        'path' => '/',
        'httponly' => true,
        'samesite' => 'Lax'
    ]);

    echo json_encode([
        'token' => $token,
        'refresh_set' => true,
        'refresh_expires_at' => $expires_at
    ]);
} catch (Exception $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["message" => "Erro ao processar refresh token"]);
}
