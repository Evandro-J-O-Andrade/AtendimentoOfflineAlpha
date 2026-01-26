<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    $pdo->beginTransaction();

    // Prepara a inserção na tabela 'solicitacao_exame'
    $stmt_solicitacao = $pdo->prepare("
        INSERT INTO solicitacao_exame
        (id_atendimento, id_exame, id_medico)
        VALUES (?, ?, ?)
    ");

    // Itera sobre a lista de IDs de exames (id_sigpat = id_exame)
    foreach ($data['exames'] as $id_exame) {
        $stmt_solicitacao->execute([
            $data['id_atendimento'],
            $id_exame, 
            $data['id_usuario']
        ]);
    }

    $pdo->commit();

    echo json_encode(["ok" => true, "mensagem" => "Exames solicitados com sucesso."]);

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao solicitar exames: " . $e->getMessage()]);
}