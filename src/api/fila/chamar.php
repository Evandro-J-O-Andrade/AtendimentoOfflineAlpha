<?php
require __DIR__ . '/../config.php';
require __DIR__ . '/../middleware.php';
require_once __DIR__ . '/../controllers/ChamadaController.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$usuario = validarToken($pdo);
$data = json_decode(file_get_contents('php://input'), true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "JSON inválido"]);
    exit;
}
$id_ffa = $data['id_ffa'] ?? null;
$usuario_chamador = $data['usuario_chamador'] ?? $usuario['id_usuario'] ?? null;
if (empty($id_ffa) || empty($usuario_chamador)) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "Campos obrigatórios ausentes: id_ffa ou usuario_chamador"]);
    exit;
}
try {
    $controller = new ChamadaController();
    $controller->chamarPaciente($id_ffa, $usuario_chamador);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => $e->getMessage()]);
}
