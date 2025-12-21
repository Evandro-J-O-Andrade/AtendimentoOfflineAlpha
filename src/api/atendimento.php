<?php
require "config.php";
require "middleware.php"; // Protege a rota!

$usuario = validarToken($pdo); // Autentica o usuário e pega seus dados

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"), true);
$id = $_GET['id'] ?? null; // ID para buscas ou manipulações

try {
    switch ($method) {
        case 'POST': // Rota para ABRIR ATENDIMENTO (Chamando sp_abertura_recepcao)
            // Lógica de abertura do atendimento (copie o conteúdo do script 3)
            // Ex: CALL sp_abertura_recepcao(...)
            echo json_encode(["ok" => true, "mensagem" => "Atendimento aberto."]);
            break;

        case 'PUT': // Rota para MOVIMENTAÇÃO (Mudar Local) ou FINALIZAR
            if ($data['acao'] === 'finalizar') {
                // Lógica de Finalizar Atendimento (copie o conteúdo do script 1 - sp_finalizar_atendimento)
                // É necessário passar o ID do médico/executor.
            } elseif ($data['acao'] === 'mudar_local') {
                // Lógica de Mudar Local (copie o conteúdo do script 2 - sp_mudar_local_sala)
            } else {
                http_response_code(400);
                echo json_encode(["erro" => "Ação PUT inválida."]);
            }
            break;

        case 'GET': // Rota para BUSCAR HISTÓRICO ou FILA
            if ($id) {
                // Lógica de BUSCA DE HISTÓRICO DETALHADO (copie o conteúdo do script 4)
            } else {
                // Lógica de BUSCA DA FILA GERAL (SELECT * FROM vw_fila_atendimento)
                $stmt = $pdo->query("SELECT * FROM vw_fila_atendimento");
                echo json_encode($stmt->fetchAll());
            }
            break;

        default:
            http_response_code(405);
            echo json_encode(["erro" => "Método não permitido."]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro no processamento: " . $e->getMessage()]);
}