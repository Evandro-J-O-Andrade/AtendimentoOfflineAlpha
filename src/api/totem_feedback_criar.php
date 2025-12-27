<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

$pdo = getPDO();

$data = json_decode(file_get_contents('php://input'), true);
$id_senha = isset($data['id_senha']) && $data['id_senha'] !== '' ? $data['id_senha'] : null;
$origem = $data['origem'] ?? null;
$nota = isset($data['nota']) ? (int)$data['nota'] : null;
$comentario = $data['comentario'] ?? null;

try {
    $stmt = $pdo->prepare('INSERT INTO totem_feedback (id_senha, origem, nota, comentario) VALUES (:id_senha, :origem, :nota, :comentario)');
    $stmt->execute([
        ':id_senha' => $id_senha,
        ':origem' => $origem,
        ':nota' => $nota,
        ':comentario' => $comentario
    ]);

    echo json_encode(['ok' => true, 'id' => $pdo->lastInsertId()]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Erro ao gravar feedback', 'message' => $e->getMessage()]);
}
