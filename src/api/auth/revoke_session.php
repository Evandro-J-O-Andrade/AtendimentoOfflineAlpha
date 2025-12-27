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
$id_refresh = isset($data['id_refresh']) ? (int)$data['id_refresh'] : 0;
if (!$id_refresh) {
    http_response_code(400);
    echo json_encode(["message" => "id_refresh obrigatório"]);
    exit;
}

$pdo = getPDO();
$usuario = validarToken($pdo);

// checar propriedade: o id_refresh pertence ao usuário ou é admin
$stmt = $pdo->prepare('SELECT id_usuario FROM usuario_refresh WHERE id_refresh = ? LIMIT 1');
$stmt->execute([$id_refresh]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row) {
    http_response_code(404);
    echo json_encode(["message" => "Sessão não encontrada"]);
    exit;
}

$owner = (int)$row['id_usuario'];
if ($owner !== $usuario['id_usuario'] && !in_array('ADMIN', $usuario['perfis'])) {
    http_response_code(403);
    echo json_encode(["message" => "Acesso negado"]);
    exit;
}

// revogar
$stmt = $pdo->prepare('UPDATE usuario_refresh SET revoked = 1 WHERE id_refresh = ?');
$stmt->execute([$id_refresh]);

// Se revogou a sessão atual, limpar cookie
// identificar sid atual
$headers = getallheaders();
$auth = $headers['Authorization'] ?? $headers['authorization'] ?? '';
if (preg_match('/Bearer\s+(\S+)/', $auth, $m)) {
    require_once __DIR__ . '/../jwt.php';
    $payload = jwt_decode($m[1]);
    if ($payload && isset($payload['sid']) && (int)$payload['sid'] === $id_refresh) {
        setcookie('refresh_token', '', [ 'expires' => time() - 3600, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax' ]);
    }
}

echo json_encode(["message" => "Sessão revogada"]);
