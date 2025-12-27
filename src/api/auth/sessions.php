<?php
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../middleware.php';
require_once __DIR__ . '/../jwt.php';

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
header('Access-Control-Allow-Methods: GET, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["message" => "Método não permitido"]);
    exit;
}

$pdo = getPDO();
$usuario = validarToken($pdo); // já retorna perfis

// identificar sid atual (se presente)
$headers = getallheaders();
$auth = $headers['Authorization'] ?? $headers['authorization'] ?? '';
$sid_current = null;
if (preg_match('/Bearer\s+(\S+)/', $auth, $m)) {
    $payload = jwt_decode($m[1]);
    if ($payload && isset($payload['sid'])) {
        $sid_current = (int)$payload['sid'];
    }
}

// se admin e query param user_id, permite ver outro usuário
$user_id = isset($_GET['user_id']) ? (int)$_GET['user_id'] : $usuario['id_usuario'];
if ($user_id !== $usuario['id_usuario']) {
    // exige perfil de admin
    if (!in_array('ADMIN', $usuario['perfis'])) {
        http_response_code(403);
        echo json_encode(["message" => "Acesso negado"]);
        exit;
    }
}

$stmt = $pdo->prepare("SELECT id_refresh, user_agent, ip, created_at, expires_at, revoked FROM usuario_refresh WHERE id_usuario = ? ORDER BY created_at DESC");
$stmt->execute([$user_id]);
$sessions = $stmt->fetchAll(PDO::FETCH_ASSOC);

// marcar sessão atual
foreach ($sessions as &$s) {
    $s['current'] = ($s['id_refresh'] === $sid_current);
}

echo json_encode($sessions);
