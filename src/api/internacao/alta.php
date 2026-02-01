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
if (empty($data['id_internacao']) || empty($data['id_usuario'])) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "Campos obrigatórios ausentes: id_internacao ou id_usuario"]);
    exit;
}
try {
    $stmt = $pdo->prepare("CALL sp_alta_internacao(:id_internacao, :id_usuario_medico)");
    $stmt->execute([
        ':id_internacao' => $data['id_internacao'],
        ':id_usuario_medico' => $data['id_usuario']
    ]);
    echo json_encode(["ok" => true, "data" => ["mensagem" => "Alta da internação registrada. Leito liberado."]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao dar alta na internação: " . $e->getMessage()]);
}
