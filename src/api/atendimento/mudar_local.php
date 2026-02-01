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
if (empty($data['id_atendimento']) || empty($data['id_usuario'])) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "Campos obrigatórios: id_atendimento, id_usuario, id_local"]);
    exit;
}
try {
    $stmt = $pdo->prepare("CALL sp_mudar_local_sala(:id_atendimento, :novo_id_local, :novo_id_sala, :id_usuario_executor)");
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':novo_id_local' => $data['id_local'] ?? null,
        ':novo_id_sala' => $data['id_sala'] ?? null,
        ':id_usuario_executor' => $data['id_usuario']
    ]);
    echo json_encode(["ok" => true, "data" => ["mensagem" => "Local do paciente atualizado com sucesso."]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao mudar local: " . $e->getMessage()]);
}
