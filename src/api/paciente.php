<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *'); // ajuste para produção
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Função simples para validar token (substituir pela sua lógica real)
function validateToken($token) {
    // Aqui você pode validar JWT ou sessão
    return $token === "SEU_TOKEN_DE_TESTE"; 
}

// Recebe o token do header Authorization
$headers = getallheaders();
if (!isset($headers['Authorization'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Token não fornecido']);
    exit;
}

$token = str_replace('Bearer ', '', $headers['Authorization']);
if (!validateToken($token)) {
    http_response_code(403);
    echo json_encode(['error' => 'Token inválido']);
    exit;
}

// Recebe o id_atendimento via POST
$data = json_decode(file_get_contents('php://input'), true);
if (!isset($data['id_atendimento'])) {
    http_response_code(400);
    echo json_encode(['error' => 'id_atendimento não fornecido']);
    exit;
}
$id_atendimento = intval($data['id_atendimento']);

// Use a conexão centralizada
require_once __DIR__ . '/config.php';
$pdo = getPDO();

// Chama a stored procedure
try {
    $stmt = $pdo->prepare("CALL sp_buscar_ficha_atendimento(:id_atendimento)");
    $stmt->bindParam(':id_atendimento', $id_atendimento, PDO::PARAM_INT);
    $stmt->execute();

    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (!$result) {
        echo json_encode([
            'dados_paciente' => [],
            'triagem' => [],
            'evolucoes' => [],
            'prescricoes' => [],
            'exames' => []
        ]);
        exit;
    }

    // Aqui você pode mapear os dados conforme a estrutura do seu banco
    $dados_paciente = [];
    $triagem = [];
    $evolucoes = [];
    $prescricoes = [];
    $exames = [];

    foreach ($result as $row) {
        // Ajuste os nomes dos campos conforme sua SP
        $dados_paciente = [
            'id_paciente' => $row['id_paciente'] ?? null,
            'nome_completo' => $row['nome_completo'] ?? null,
            'data_nascimento' => $row['data_nascimento'] ?? null,
            'sexo' => $row['sexo'] ?? null,
        ];

        $triagem[] = [
            'pressao' => $row['pressao'] ?? null,
            'temperatura' => $row['temperatura'] ?? null,
            'saturacao' => $row['saturacao'] ?? null,
        ];

        $evolucoes[] = [
            'data' => $row['data_evolucao'] ?? null,
            'descricao' => $row['descricao_evolucao'] ?? null,
        ];

        $prescricoes[] = [
            'medicamento' => $row['medicamento'] ?? null,
            'dosagem' => $row['dosagem'] ?? null,
            'frequencia' => $row['frequencia'] ?? null,
        ];

        $exames[] = [
            'exame' => $row['exame'] ?? null,
            'resultado' => $row['resultado'] ?? null,
            'data' => $row['data_exame'] ?? null,
        ];
    }

    echo json_encode([
        'dados_paciente' => $dados_paciente,
        'triagem' => $triagem,
        'evolucoes' => $evolucoes,
        'prescricoes' => $prescricoes,
        'exames' => $exames
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Erro ao buscar ficha', 'message' => $e->getMessage()]);
}
?>