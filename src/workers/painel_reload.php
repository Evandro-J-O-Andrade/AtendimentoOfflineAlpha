<?php
// src/workers/painel_reload.php

require_once __DIR__ . '/../api/config.php';

$pdo = getPDO();

try {

    $pdo->exec("
        UPDATE painel_status
        SET precisa_reload = 1,
            atualizado_em = NOW()
        WHERE ativo = 1
    ");

    echo "[OK] Painéis marcados para reload\n";

} catch (Throwable $e) {
    echo "[ERRO] painel_reload: {$e->getMessage()}\n";
}
