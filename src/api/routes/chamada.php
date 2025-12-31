<?php
require_once __DIR__ . '/../controllers/ChamadaController.php';

$controller = new ChamadaController();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['id_ffa']) || !isset($data['usuario_chamador'])) {
        http_response_code(400);
        echo json_encode(['erro' => 'Parâmetros id_ffa e usuario_chamador obrigatórios']);
        exit;
    }

    $controller->chamarPaciente($data['id_ffa'], $data['usuario_chamador']);
}
