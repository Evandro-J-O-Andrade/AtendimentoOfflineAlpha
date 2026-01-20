<?php
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

function carregarPerfisUsuario(PDO $pdo, int $id_usuario): array {
    $stmt = $pdo->prepare("
        SELECT DISTINCT pf.nome
        FROM usuario_sistema us
        JOIN perfil pf ON pf.id_perfil = us.id_perfil
        WHERE us.id_usuario = ?
          AND us.ativo = 1
    ");
    $stmt->execute([$id_usuario]);
    $perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

    if (!$perfis) return [];

    $out = [];
    foreach ($perfis as $p) {
        if ($p === 'MASTER') $out[] = 'ADMIN_MASTER';
        $out[] = $p;
    }
    return array_values(array_unique($out));
}

$refresh_hash = hash('sha256', $refresh);

// localizar token válido
$stmt = $pdo->prepare("
    SELECT id_refresh, id_usuario
    FROM usuario_refresh
    WHERE token_hash = ?
      AND revoked = 0
      AND expires_at >= NOW()
    LIMIT 1
");
$stmt->execute([$refresh_hash]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) {
    http_response_code(401);
    echo json_encode(["message" => "Refresh token inválido ou expirado"]);
    exit;
}

$id_refresh = (int)$row['id_refresh'];
$id_usuario = (int)$row['id_usuario'];

$pdo->beginTransaction();
try {
    // revoga antigo
    $stmt = $pdo->prepare('UPDATE usuario_refresh SET revoked = 1 WHERE id_refresh = ?');
    $stmt->execute([$id_refresh]);

    // cria novo refresh
    $new_refresh = bin2hex(random_bytes(64));
    $new_hash = hash('sha256', $new_refresh);
    $expires_at = date('Y-m-d H:i:s', time() + 30 * 24 * 3600);
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? null;
    $ip = $_SERVER['REMOTE_ADDR'] ?? null;

    $stmt = $pdo->prepare('
        INSERT INTO usuario_refresh (id_usuario, token_hash, expires_at, user_agent, ip)
        VALUES (?, ?, ?, ?, ?)
    ');
    $stmt->execute([$id_usuario, $new_hash, $expires_at, substr((string)$user_agent, 0, 255), $ip]);
    $new_id = (int)$pdo->lastInsertId();

    // perfis pela fonte da verdade
    $perfis = carregarPerfisUsuario($pdo, $id_usuario);
    if (!$perfis) {
        $pdo->rollBack();
        http_response_code(403);
        echo json_encode(["message" => "Usuário sem perfil"]);
        exit;
    }

    // novo access token com sid novo
    $token = jwt_encode(['id_usuario' => $id_usuario, 'perfis' => $perfis, 'sid' => $new_id], 3600);

    $pdo->commit();

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
