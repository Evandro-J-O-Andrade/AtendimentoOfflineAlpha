<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    // A procedure que finaliza o atendimento (Alta, Óbito, Transferência, etc.)
    // Vamos chamar o SP 'sp_finalizar_atendimento' (assumindo que você o criou)
    $stmt = $pdo->prepare("
        CALL sp_finalizar_atendimento(
            :id_atendimento, 
            :id_usuario_medico, 
            :desfecho, 
            :observacao
        )
    ");
    
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':id_usuario_medico' => $data['id_usuario'],
        ':desfecho' => $data['desfecho'], // Ex: 'ALTA_MEDICA', 'TRANSFERENCIA', 'OBITO'
        ':observacao' => $data['observacao']
    ]);

    echo json_encode(["ok" => true, "mensagem" => "Atendimento finalizado com sucesso."]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao finalizar atendimento: " . $e->getMessage()]);
}