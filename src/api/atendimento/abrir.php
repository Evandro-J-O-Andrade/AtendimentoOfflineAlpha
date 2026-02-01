<?php
require __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$data = json_decode(file_get_contents("php://input"), true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "JSON inválido"]);
    exit;
}
$required = ['nome_completo', 'tipo_atendimento', 'id_usuario_logado'];
foreach ($required as $field) {
    if (empty($data[$field])) {
        http_response_code(400);
        echo json_encode(["ok" => false, "error" => "Campo obrigatório ausente: $field"]);
        exit;
    }
}
try {
    $stmt = $pdo->prepare("
        CALL sp_abertura_recepcao(
            :nome, :cpf, :cns, :data_nascimento, :sexo, 
            :tipo, :chegada, :prioridade, :motivo, :destino, :usuario_id
        )
    ");
    $stmt->execute([
        ':nome' => $data['nome_completo'],
        ':cpf' => $data['cpf'] ?? null,
        ':cns' => $data['cns'] ?? null,
        ':data_nascimento' => $data['data_nascimento'] ?? null,
        ':sexo' => $data['sexo'] ?? null,
        ':tipo' => $data['tipo_atendimento'],
        ':chegada' => $data['meio_chegada'] ?? null,
        ':prioridade' => $data['prioridade'] ?? null,
        ':motivo' => $data['motivo_procura'] ?? null,
        ':destino' => $data['destino_inicial'] ?? null,
        ':usuario_id' => $data['id_usuario_logado']
    ]);
    echo json_encode(["ok" => true, "data" => ["mensagem" => "Atendimento aberto com sucesso."]]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao abrir atendimento: " . $e->getMessage()]);
}
