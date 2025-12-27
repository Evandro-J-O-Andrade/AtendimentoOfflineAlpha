<?php
require '../config.php'; // conexão com o banco

header('Content-Type: application/json');

try {
    $stmt = $conn->prepare("SELECT id_local, nome, tipo FROM local_atendimento WHERE ativo = 1");
    $stmt->execute();
    $locais = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($locais);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
