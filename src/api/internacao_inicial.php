<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    // 1. Chama a SP para registrar a internação
    $stmt = $pdo->prepare("
        CALL sp_internacao_paciente(
            :id_atendimento, 
            :id_leito, 
            :id_usuario_medico, 
            :data_prevista_alta, 
            :observacoes
        )
    ");
    
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':id_leito' => $data['id_leito'],
        ':id_usuario_medico' => $data['id_usuario'], // ID do médico
        ':data_prevista_alta' => $data['data_prevista_alta'] ?? NULL,
        ':observacoes' => $data['observacoes'] ?? NULL
    ]);

    echo json_encode(["ok" => true, "mensagem" => "Paciente internado com sucesso."]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao iniciar internação: " . $e->getMessage()]);
}