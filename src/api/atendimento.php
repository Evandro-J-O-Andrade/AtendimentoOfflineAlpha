<?php
require "config.php";       // Contém getPDO()
require "middleware.php";   // Contém validarToken()

header("Content-Type: application/json; charset=UTF-8");

// --- Inicializa PDO
$pdo = getPDO();

// --- Autentica o usuário e pega dados do token
try {
    $usuario = validarToken($pdo); 
} catch (Exception $e) {
    http_response_code(401);
    echo json_encode(["erro" => "Token inválido ou expirado"]);
    exit;
}

// --- Captura método, dados e parâmetros
$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"), true);
$id = $_GET['id'] ?? null;

try {
    switch ($method) {
        case 'POST': // Abrir atendimento
            // Exemplo de chamada a procedure:
            // $stmt = $pdo->prepare("CALL sp_abertura_recepcao(?, ?)");
            // $stmt->execute([$usuario['id'], $data['paciente_id']]);
            echo json_encode(["ok" => true, "mensagem" => "Atendimento aberto."]);
            break;

        case 'PUT': // Movimentação ou finalizar
            if (!isset($data['acao'])) {
                http_response_code(400);
                echo json_encode(["erro" => "Ação PUT obrigatória"]);
                exit;
            }

            if ($data['acao'] === 'finalizar') {
                // Lógica de finalizar atendimento
                // Ex: CALL sp_finalizar_atendimento($id, $usuario['id'])
                echo json_encode(["ok" => true, "mensagem" => "Atendimento finalizado."]);
            } elseif ($data['acao'] === 'mudar_local') {
                // Lógica de mudar local
                // Ex: CALL sp_mudar_local_sala($id, $data['nova_sala'])
                echo json_encode(["ok" => true, "mensagem" => "Local alterado."]);
            } else {
                http_response_code(400);
                echo json_encode(["erro" => "Ação PUT inválida."]);
            }
            break;

        case 'GET': // Buscar histórico ou fila
            if ($id) {
                // Buscar histórico detalhado
                // Ex: SELECT * FROM vw_historico_atendimento WHERE id_atendimento = ?
                // $stmt = $pdo->prepare("SELECT * FROM vw_historico_atendimento WHERE id_atendimento = ?");
                // $stmt->execute([$id]);
                // echo json_encode($stmt->fetchAll());
            } else {
                // Buscar fila geral
                $stmt = $pdo->query("SELECT * FROM vw_fila_atendimento");
                echo json_encode($stmt->fetchAll());
            }
            break;

        default:
            http_response_code(405);
            echo json_encode(["erro" => "Método não permitido"]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro no processamento: " . $e->getMessage()]);
}
