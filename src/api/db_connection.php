<?php
/**
 * Conexão única com o banco usando PDO
 * Usado por auth.php / login.php
 */

function getPDO() {
    static $pdo = null;

    if ($pdo === null) {
        $host = '127.0.0.1';
        $db   = 'pronto_atendimento'; // ⚠️ CONFIRA O NOME DO BANCO
        $user = 'root';
        $pass = 'root'; // padrão XAMPP
        $port = 3306; // SUA PORTA REAL

        $dsn = "mysql:host=$host;dbname=$db;port=$port;charset=utf8mb4";

        try {
            $pdo = new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                'message' => 'Erro de conexão com o banco',
                'error' => $e->getMessage()
            ]);
            exit;
        }
    }

    return $pdo;
}
