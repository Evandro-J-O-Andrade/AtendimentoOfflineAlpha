<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    // O SP sp_registrar_triagem insere na triagem e atualiza o status para 'EM_ATENDIMENTO'
    $stmt = $pdo->prepare("
        CALL sp_registrar_triagem(
            :id_atendimento, 
            :id_risco, 
            :queixa, 
            :sinais, 
            :obs, 
            :enfermeiro_id
        )
    ");
    
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':id_risco' => $data['id_risco'], // ID da classificacao_risco
        ':queixa' => $data['queixa'],
        ':sinais' => json_encode($data['sinais_vitais']), // Sinais vitais são armazenados como JSON
        ':obs' => $data['observacoes'],
        ':enfermeiro_id' => $data['id_usuario']
    ]);

    echo json_encode(["ok" => true, "mensagem" => "Triagem registrada e status atualizado para EM_ATENDIMENTO."]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao registrar triagem: " . $e->getMessage()]);
}