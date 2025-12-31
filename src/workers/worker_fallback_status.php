<?php
require __DIR__ . '/../api/config.php';

$pdo = getPDO();

/*
 Exemplo:
 EM_ATENDIMENTO_MEDICO há mais de 6h sem ação
 → OBSERVACAO
*/
$sql = "
SELECT id
FROM ffa
WHERE status = 'EM_ATENDIMENTO_MEDICO'
  AND atualizado_em < (NOW() - INTERVAL 6 HOUR)
";

$rows = $pdo->query($sql)->fetchAll();

foreach ($rows as $row) {
    $pdo->prepare("
        UPDATE ffa
        SET status = 'OBSERVACAO',
            atualizado_em = NOW()
        WHERE id = ?
    ")->execute([$row['id']]);

    $pdo->prepare("
        INSERT INTO auditoria_ffa
            (id_ffa, tipo_evento, acao, timestamp)
        VALUES
            (?, 'STATUS', 'Fallback automático para OBSERVACAO', NOW())
    ")->execute([$row['id']]);
}
