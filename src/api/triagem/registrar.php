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
$required = ['id_atendimento', 'id_risco', 'id_usuario'];
foreach ($required as $f) {
    if (empty($data[$f])) {
        http_response_code(400);
        echo json_encode(["ok" => false, "error" => "Campo obrigatório ausente: $f"]);
        exit;
    }
}
try {
    $stmt = $pdo->prepare(
        "CALL sp_registrar_triagem(
            :id_atendimento, :id_risco, :queixa, :sinais, :obs, :enfermeiro_id
        )"
    );
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':id_risco' => $data['id_risco'],
        ':queixa' => $data['queixa'] ?? null,
        ':sinais' => isset($data['sinais_vitais']) ? json_encode($data['sinais_vitais']) : null,
        ':obs' => $data['observacoes'] ?? null,
        ':enfermeiro_id' => $data['id_usuario']
    ]);

    echo json_encode(["ok" => true, "data" => ["mensagem" => "Triagem registrada com sucesso."]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao registrar triagem: " . $e->getMessage()]);
}
