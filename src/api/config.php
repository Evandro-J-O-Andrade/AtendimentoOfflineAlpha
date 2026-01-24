<?php
// api/config.php
// RESPONSABILIDADE ÚNICA: conexão com o banco

// JWT (use variável de ambiente em produção)
if (!defined('JWT_SECRET')) {
    define('JWT_SECRET', getenv('JWT_SECRET') ?: 'dev-secret-please-change');
}

function getPDO(): PDO {
    static $pdo = null;

    if ($pdo === null) {
        $host = getenv('DB_HOST') ?: '127.0.0.1';
        $db   = getenv('DB_NAME') ?: 'pronto_atendimento';
        $user = getenv('DB_USER') ?: 'root';
        $pass = getenv('DB_PASS') ?: 'root'; // XAMPP padrão (ajuste se necessário)
        $port = intval(getenv('DB_PORT') ?: 3306);

        try {
            $pdo = new PDO(
                "mysql:host=$host;dbname=$db;port=$port;charset=utf8mb4",
                $user,
                $pass,
                [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES   => false,
                ]
            );
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                'erro' => 'Falha ao conectar ao banco de dados'
            ]);
            exit;
        }
    }

    return $pdo;
}

// Compatibilidade: scripts antigos esperam $pdo global.
// (Scripts novos podem usar getPDO() diretamente.)
$pdo = getPDO();
