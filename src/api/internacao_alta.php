<?php
require "config.php";

$data = json_decode(file_get_contents("php://input"), true);

try {
    // 1. Chama a SP para registrar a alta da internação (liberando o leito)
    $stmt = $pdo->prepare("
        CALL sp_alta_internacao(
            :id_internacao, 
            :id_usuario_medico
        )
    ");
    
    $stmt->execute([
        ':id_internacao' => $data['id_internacao'],
        ':id_usuario_medico' => $data['id_usuario']
    ]);

    echo json_encode(["ok" => true, "mensagem" => "Alta da internação registrada. Leito liberado."]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao dar alta na internação: " . $e->getMessage()]);
}