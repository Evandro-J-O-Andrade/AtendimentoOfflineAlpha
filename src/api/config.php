<?php
// api/config.php - Configurações de Banco de Dados

// O cabeçalho JSON é enviado aqui para garantir que todas as respostas sejam JSON
header('Content-Type: application/json; charset=UTF-8');
// Você pode adicionar um cabeçalho CORS padrão aqui, se preferir
// header("Access-Control-Allow-Origin: *"); 
header("Access-Control-Allow-Origin: http://localhost:5173");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");
function getPDO() {
    // Usa static para que a conexão seja feita apenas uma vez
    static $pdo = null;

    if ($pdo === null) {
        $host = '127.0.0.1'; // Localhost padrão
        $db   = 'pronto_atendimento'; // Seu banco de dados
        $user = 'root'; // Usuário padrão do XAMPP
        $pass = 'root'; // CORRIGIDO: Senha padrão do XAMPP é vazia
        $port = 3306;

        try {
            $pdo = new PDO(
                "mysql:host=$host;dbname=$db;port=$port;charset=utf8mb4",
                $user,
                $pass,
                [
                    // Lançar exceções em caso de erro (melhor para debug)
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]
            );
        } catch (PDOException $e) {
            // Em caso de falha de conexão, para tudo e retorna erro 500
            http_response_code(500);
            echo json_encode([
                'message' => 'Erro interno do servidor: Falha ao conectar ao banco de dados.',
                'error' => $e->getMessage()
            ]);
            exit;
        }
    }

    return $pdo;
}