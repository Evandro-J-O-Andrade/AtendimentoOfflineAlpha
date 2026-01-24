<?php
require_once __DIR__ . "/config.php";
require_once __DIR__ . "/middleware.php";

header('Content-Type: application/json; charset=utf-8');

try {
    // Protege endpoint
    validarToken($pdo);

    $stmt = $pdo->query(
        "SELECT id_local, nome, tipo, ativo, id_unidade\n" .
        "  FROM local_atendimento\n" .
        " WHERE COALESCE(ativo,1)=1\n" .
        " ORDER BY nome"
    );
    echo json_encode($stmt->fetchAll(), JSON_UNESCAPED_UNICODE);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao listar locais"], JSON_UNESCAPED_UNICODE);
}