<?php
// src/workers/chamada_automatica.php
// Worker universal para todos os painéis
// Seleciona próximo paciente, respeita prioridade, mas NÃO chama automaticamente

require_once __DIR__ . '/../api/config.php';

$pdo = getPDO();

try {

    // Seleciona o próximo paciente com prioridade:
    // 1️⃣ Pediátrico + vermelho → topo absoluto
    // 2️⃣ Outros vermelhos → prioridade sobre menores
    $stmt = $pdo->query("
        SELECT f.id, f.gpat, f.id_paciente, p.nome_completo, f.classificacao_manchester,
               pl.tipo_plantao, pl.nome_medico
        FROM ffa f
        JOIN pessoa p ON f.id_paciente = p.id_pessoa
        LEFT JOIN plantao pl 
            ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
            AND pl.ativo = 1
        WHERE f.status = 'AGUARDANDO_CHAMADA_MEDICO'
        ORDER BY 
            CASE 
                WHEN pl.tipo_plantao = 'PEDIATRIA' AND f.classificacao_manchester = 'VERMELHO' THEN 1
                ELSE 2
            END,
            FIELD(f.classificacao_manchester, 'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
            f.criado_em
        LIMIT 1
    ");

    $ffa = $stmt->fetch();

    if (!$ffa) {
        echo "[INFO] Nenhum paciente aguardando\n";
        exit;
    }

    // Apenas informa qual é o próximo paciente
    echo "[INFO] Próximo paciente: ID {$ffa['id']}, Nome {$ffa['nome_completo']}, Senha {$ffa['gpat']}, Plantão {$ffa['tipo_plantao']}, Médico {$ffa['nome_medico']}, Classificação {$ffa['classificacao_manchester']}\n";

    // Auditoria opcional: registra que este paciente está no topo da fila (sem chamar)
    $pdo->prepare("
        INSERT INTO auditoria_excecoes (id_ffa, id_paciente, motivo, chamado_por, criado_em)
        VALUES (?, ?, 'Prioridade fila universal', 'SYSTEM', NOW())
    ")->execute([$ffa['id'], $ffa['id_paciente']]);

} catch (Throwable $e) {
    echo "[ERRO] chamada_automatica: {$e->getMessage()}\n";
}
