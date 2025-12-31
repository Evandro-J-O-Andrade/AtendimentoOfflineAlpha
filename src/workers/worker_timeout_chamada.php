<?php
require __DIR__ . '/../api/config.php';

$pdo = getPDO();

/*
 Regra:
 - status CHAMANDO_*
 - passou 2 minutos
 - não virou EM_ATENDIMENTO
*/
$sql = "
SELECT id, status
FROM ffa
WHERE status IN ('CHAMANDO_MEDICO')
  AND atualizado_em < (NOW() - INTERVAL 2 MINUTE)
";

$ffas = $pdo->query($sql)->fetchAll();

foreach ($ffas as $ffa) {
    $pdo->beginTransaction();

    try {
        // Volta para aguardando
        $stmt = $pdo->prepare("
            UPDATE ffa
            SET status = 'AGUARDANDO_CHAMADA_MEDICO',
                atualizado_em = NOW()
            WHERE id = ?
        ");
        $stmt->execute([$ffa['id']]);

        // Auditoria
        $stmt = $pdo->prepare("
            INSERT INTO auditoria_ffa
                (id_ffa, tipo_evento, acao, timestamp)
            VALUES
                (?, 'STATUS', 'TIMEOUT DE CHAMADA - paciente não compareceu', NOW())
        ");
        $stmt->execute([$ffa['id']]);

        $pdo->commit();
    } catch (Exception $e) {
        $pdo->rollBack();
    }
}
