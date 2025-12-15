<?php
// config.php - Conexão Centralizada
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$db   = "pronto_atendimento"; // NOME DO BANCO CONFERIDO
$user = "root";
$pass = ""; // Ajuste conforme sua senha no WAMPP/MySQL

try {
    $pdo = new PDO(
        "mysql:host=$host;dbname=$db;charset=utf8mb4",
        $user,
        $pass,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );
} catch (PDOException $e) {
    http_response_code(500);
    // Em ambiente de produção, não exibir $e->getMessage()
    echo json_encode(["erro" => "Erro de conexão com o Banco de Dados."]); 
    exit;
}
?>