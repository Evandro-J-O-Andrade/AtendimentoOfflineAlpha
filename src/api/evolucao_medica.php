<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

try {
    $pdo->beginTransaction();

    // 1. ANAMNESE
    $stmt_anamnese = $pdo->prepare("
        INSERT INTO anamnese (id_atendimento, descricao, id_usuario)
        VALUES (?, ?, ?)
    ");
    $stmt_anamnese->execute([
        $data['id_atendimento'],
        $data['anamnese'],
        $data['id_usuario']
    ]);

    // 2. EXAME FÍSICO
    $stmt_exame = $pdo->prepare("
        INSERT INTO exame_fisico (id_atendimento, descricao, id_usuario)
        VALUES (?, ?, ?)
    ");
    $stmt_exame->execute([
        $data['id_atendimento'],
        $data['exame_fisico'],
        $data['id_usuario']
    ]);
    
    // 3. HIPÓTESE DIAGNÓSTICA (opcional - usa cid10)
    if (!empty($data['diagnostico_cid'])) {
        $stmt_hipotese = $pdo->prepare("
            INSERT INTO hipotese_diagnostica (id_atendimento, cid10, id_medico, principal)
            VALUES (?, ?, ?, TRUE)
        ");
        $stmt_hipotese->execute([
            $data['id_atendimento'],
            $data['diagnostico_cid'],
            $data['id_usuario']
        ]);
    }

    $pdo->commit();

    echo json_encode(["ok" => true, "mensagem" => "Evolução e Diagnóstico registrados."]);

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao registrar evolução: " . $e->getMessage()]);
}