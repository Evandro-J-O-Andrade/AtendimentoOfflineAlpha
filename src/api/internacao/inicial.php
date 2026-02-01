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
$required = ['id_atendimento', 'id_usuario'];
foreach ($required as $f) {
    if (empty($data[$f])) {
        http_response_code(400);
        echo json_encode(["ok" => false, "error" => "Campo obrigatório ausente: $f"]);
        exit;
    }
}
try {
    $stmt = $pdo->prepare(
        "CALL sp_internacao_paciente(
            :id_atendimento, :id_leito, :id_usuario_medico, :data_prevista_alta, :observacoes
        )"
    );
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':id_leito' => $data['id_leito'] ?? null,
        ':id_usuario_medico' => $data['id_usuario'],
        ':data_prevista_alta' => $data['data_prevista_alta'] ?? null,
        ':observacoes' => $data['observacoes'] ?? null
    ]);

    echo json_encode(["ok" => true, "data" => ["mensagem" => "Paciente internado com sucesso."]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao iniciar internação: " . $e->getMessage()]);
}
