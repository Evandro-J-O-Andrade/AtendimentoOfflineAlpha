<?php
require __DIR__ . '/../config.php';
require __DIR__ . '/../middleware.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$usuario = validarToken($pdo);
try {
    $stmt = $pdo->query("SELECT * FROM vw_fila_atendimento");
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode(["ok" => true, "data" => $rows]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao buscar fila: " . $e->getMessage()]);
}
