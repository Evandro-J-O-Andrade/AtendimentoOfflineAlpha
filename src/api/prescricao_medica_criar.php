<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    $pdo->beginTransaction();

    // 1. Insere o cabeçalho da prescrição (na tabela prescricao_medica)
    $stmt = $pdo->prepare("
        INSERT INTO prescricao_medica 
        (id_atendimento, id_usuario_medico)
        VALUES (?, ?)
    ");

    $stmt->execute([
        $data['id_atendimento'],
        $data['id_usuario']
    ]);

    $id_prescricao = $pdo->lastInsertId();

    // 2. Insere os itens da prescrição (na tabela prescricao_item)
    $item_stmt = $pdo->prepare("
        INSERT INTO prescricao_item 
        (id_prescricao, medicamento, dose, via, frequencia, duracao)
        VALUES (?, ?, ?, ?, ?, ?)
    ");

    foreach ($data['itens'] as $item) {
        $item_stmt->execute([
            $id_prescricao,
            $item['medicamento'],
            $item['dose'],
            $item['via'],
            $item['frequencia'],
            $item['duracao']
        ]);
    }

    $pdo->commit();

    echo json_encode(["ok" => true, "mensagem" => "Prescrição médica criada com sucesso."]);

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao criar prescrição: " . $e->getMessage()]);
}