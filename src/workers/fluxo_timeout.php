<?php
// src/workers/fluxo_timeout.php

require_once __DIR__ . '/../api/config.php';

$pdo = getPDO();

try {

    // Médico chamou e ninguém apareceu (2 min)
    $pdo->prepare("
        UPDATE ffa
        SET status = 'AGUARDANDO_CHAMADA_MEDICO',
            layout = 'PAINEL_MEDICO',
            atualizado_em = NOW()
        WHERE status = 'CHAMANDO_MEDICO'
          AND TIMESTAMPDIFF(MINUTE, atualizado_em, NOW()) >= 2
    ")->execute();

    // RX chamou e ninguém apareceu (3 min)
    $pdo->prepare("
        UPDATE ffa
        SET status = 'AGUARDANDO_RX',
            layout = 'PAINEL_RX',
            atualizado_em = NOW()
        WHERE status = 'CHAMANDO_RX'
          AND TIMESTAMPDIFF(MINUTE, atualizado_em, NOW()) >= 3
    ")->execute();

    echo "[OK] fluxo_timeout executado\n";

} catch (Throwable $e) {
    echo "[ERRO] fluxo_timeout: {$e->getMessage()}\n";
}
