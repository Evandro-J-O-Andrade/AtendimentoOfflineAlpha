<?php
require "config.php";
require "middleware.php"; 

$usuario = validarToken($pdo);

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"), true);

try {
    switch ($method) {
        case 'POST':
            if ($data['tipo'] === 'evolucao') {
                // Lógica de Registrar Evolução Médica (Anamnese, Exame Físico, etc.)
            } elseif ($data['tipo'] === 'prescricao') {
                // Lógica de Criar Prescrição Médica (usando transação)
            } else {
                http_response_code(400);
                echo json_encode(["erro" => "Tipo de POST médico inválido."]);
            }
            break;

        // ... GET para buscar o histórico de evoluções/prescrições

        default:
            http_response_code(405);
            echo json_encode(["erro" => "Método não permitido."]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro no processamento: " . $e->getMessage()]);
}