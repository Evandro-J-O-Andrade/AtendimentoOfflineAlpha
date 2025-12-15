<?php
require "config.php";

try {
    $stmt = $pdo->query("SELECT id_local, nome FROM local_atendimento ORDER BY nome");
    echo json_encode($stmt->fetchAll());
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao listar locais: " . $e->getMessage()]);
}