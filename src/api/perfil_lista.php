<?php
require "config.php";
$pdo = getPDO();

try {
    // Lista todos os perfis cadastrados (Médico, Recepcionista, etc.)
    $stmt = $pdo->query("SELECT id_perfil, nome FROM perfil ORDER BY nome");
    
    echo json_encode($stmt->fetchAll());

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao listar perfis: " . $e->getMessage()]);
}