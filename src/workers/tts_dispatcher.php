<?php
// src/workers/tts_dispatcher.php
// Dispara TTS apenas para chamadas manuais

require_once __DIR__ . '/../api/config.php';

$pdo = getPDO();

try {

    $eventos = $pdo->query("
        SELECT a.id, f.gpat, f.layout
        FROM auditoria_ffa a
        JOIN ffa f ON f.id = a.id_ffa
        WHERE a.tipo_evento = 'CHAMADA_MEDICA'
          AND COALESCE(a.tts_enviado,0) = 0
        ORDER BY a.timestamp
        LIMIT 10
    ")->fetchAll();

    foreach ($eventos as $e) {
        // Aqui entra integração com Google TTS
        echo "🔊 {$e['gpat']} comparecer em {$e['layout']}\n";

        $pdo->prepare("
            UPDATE auditoria_ffa
            SET tts_enviado = 1
            WHERE id = ?
        ")->execute([$e['id']]);
    }

} catch (Throwable $e) {
    echo "[ERRO] tts_dispatcher: {$e->getMessage()}\n";
}
