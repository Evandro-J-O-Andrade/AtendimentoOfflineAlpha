<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    // Chama o SP que move o paciente, atualiza o id_local_atual e id_sala_atual
    $stmt = $pdo->prepare("
        CALL sp_mudar_local_sala(
            :id_atendimento, 
            :novo_id_local, 
            :novo_id_sala, 
            :id_usuario_executor
        )
    ");
    
    $stmt->execute([
        ':id_atendimento' => $data['id_atendimento'],
        ':novo_id_local' => $data['id_local'],
        ':novo_id_sala' => $data['id_sala'] ?? NULL, // Permite que a sala seja opcional
        ':id_usuario_executor' => $data['id_usuario']
    ]);

    echo json_encode(["ok" => true, "mensagem" => "Local do paciente atualizado com sucesso."]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao mudar o local: " . $e->getMessage()]);
}