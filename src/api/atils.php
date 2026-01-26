<?php
// utils.php - API para listagem de dados auxiliares (dropdowns, cadastros mestres)
require "config.php";
$pdo = getPDO();
require "middleware.php"; 


header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Methods: GET, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

// A proteção da rota é crucial, mesmo para dados auxiliares
$usuario = validarToken($pdo); 

// Pega o parâmetro 'resource' da URL (ex: ?resource=local_atendimento)
$resource = $_GET['resource'] ?? '';

if (empty($resource)) {
    http_response_code(400);
    echo json_encode(["erro" => "O parâmetro 'resource' é obrigatório."]);
    exit;
}

try {
    $results = [];

    // Define qual tabela buscar e as colunas de ID e Nome
    switch ($resource) {
        case 'local_atendimento':
            // Tabela: local_atendimento (necessário para mudar o local)
            $stmt = $pdo->query("SELECT id_local AS id, nome, tipo FROM local_atendimento ORDER BY nome");
            $results = $stmt->fetchAll();
            break;

        case 'sala':
            // Tabela: sala (necessário para alocar em consultórios/UTI)
            $stmt = $pdo->query("SELECT id_sala AS id, nome, id_local FROM sala ORDER BY nome");
            $results = $stmt->fetchAll();
            break;
            
        case 'leito':
            // Tabela: leito (necessário para internação)
            $stmt = $pdo->query("SELECT id_leito AS id, nome, tipo_leito, id_sala, ocupado FROM leito ORDER BY nome");
            $results = $stmt->fetchAll();
            break;

        case 'classificacao_risco':
            // Tabela: classificacao_risco (necessário para a Triagem)
            $stmt = $pdo->query("SELECT id_risco AS id, nome, cor, descricao FROM classificacao_risco ORDER BY nivel_prioridade");
            $results = $stmt->fetchAll();
            break;

        case 'especialidade':
            // Tabela: especialidade (para encaminhamento de pacientes ou filtro de médicos)
            $stmt = $pdo->query("SELECT id_especialidade AS id, nome, ativa FROM especialidade ORDER BY nome");
            $results = $stmt->fetchAll();
            break;

        case 'perfil':
            // Tabela: perfil (para cadastro de usuários)
            $stmt = $pdo->query("SELECT id_perfil AS id, nome FROM perfil ORDER BY nome");
            $results = $stmt->fetchAll();
            break;
            
        case 'exame':
            // Tabela: exame (a lista de exames disponíveis para solicitação)
            $stmt = $pdo->query("SELECT id_exame AS id, nome, sigla FROM exame WHERE ativo = 1 ORDER BY nome");
            $results = $stmt->fetchAll();
            break;

        default:
            http_response_code(404);
            echo json_encode(["erro" => "Recurso '" . htmlspecialchars($resource) . "' não encontrado."]);
            exit;
    }

    // Retorna os dados em formato JSON
    echo json_encode($results);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro ao buscar dados de cadastro: " . $e->getMessage()]);
}