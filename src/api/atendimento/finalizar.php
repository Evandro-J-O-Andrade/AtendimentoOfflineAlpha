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
    echo json_encode(["ok" => false, "error" => "Campos obrigatórios: id_atendimento, id_usuario"]);
    exit;
}
try {
    $stmt = $pdo->prepare("CALL sp_finalizar_atendimento(:id_atendimento, :id_usuario_medico, :desfecho, :observacao)");
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':id_usuario_medico' => $data['id_usuario'],
        ':desfecho' => $data['desfecho'] ?? 'ALTA_MEDICA',
        ':observacao' => $data['observacao'] ?? null
    ]);
    echo json_encode(["ok" => true, "data" => ["mensagem" => "Atendimento finalizado com sucesso."]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao finalizar atendimento: " . $e->getMessage()]);
}
