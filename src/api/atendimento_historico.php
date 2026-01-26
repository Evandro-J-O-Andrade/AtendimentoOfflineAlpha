<?php
require "config.php";
$pdo = getPDO();

$id_atendimento = $_GET['id'] ?? null;

if (!$id_atendimento) {
    http_response_code(400);
    echo json_encode(["erro" => "ID do atendimento é obrigatório."]);
    exit;
}

try {
    $historico = [];

    // --- Busca Dados Básicos do Atendimento (incluindo o Protocolo e Pessoa) ---
    $stmt_base = $pdo->prepare("
        SELECT a.protocolo, p.nome_completo, a.status_atendimento, a.data_abertura 
        FROM atendimento a JOIN pessoa p ON p.id_pessoa = a.id_pessoa 
        WHERE a.id_atendimento = ?
    ");
    $stmt_base->execute([$id_atendimento]);
    $historico['base'] = $stmt_base->fetch();


    // --- Busca Triagem ---
    $stmt_triagem = $pdo->prepare("
        SELECT t.*, cr.cor AS risco_cor 
        FROM triagem t JOIN classificacao_risco cr ON cr.id_risco = t.id_risco
        WHERE t.id_atendimento = ?
    ");
    $stmt_triagem->execute([$id_atendimento]);
    $historico['triagem'] = $stmt_triagem->fetch();


    // --- Busca Anamnese e Exame Físico (Último Registro) ---
    $stmt_anamnese = $pdo->prepare("
        SELECT a.descricao, u.login AS medico 
        FROM anamnese a JOIN usuario u ON u.id_usuario = a.id_usuario
        WHERE a.id_atendimento = ? ORDER BY a.data_registro DESC LIMIT 1
    ");
    $stmt_anamnese->execute([$id_atendimento]);
    $historico['anamnese'] = $stmt_anamnese->fetch();
    
    // ... e assim por diante, para Prescricoes, Solicitacao_Exame, Documento, etc.
    
    echo json_encode($historico);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao buscar histórico: " . $e->getMessage()]);
}