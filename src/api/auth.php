<?php
// auth.php - Lida com Login e Validação de Sessão
require "config.php"; 
// Middleware não é necessário aqui, pois esta é a rota de autenticação

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? null;
$data = json_decode(file_get_contents("php://input"), true);

switch ($method) {
    case 'POST':
        // ROTA DE LOGIN (corresponde ao login_seguro.php que criamos)
        // ... (todo o código de SELECT, password_verify e geração de token)
        // ...
        // Se o login for bem-sucedido:
        // echo json_encode(["ok" => true, "token" => $token, "usuario" => $user]);
        break;

    case 'GET':
        if ($action === 'validate') {
            // ROTA DE VALIDAÇÃO DE TOKEN (Etapa 5)
            
            // 1. Tenta obter o token do Header (Authorization: Bearer <token>)
            $headers = getallheaders();
            $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
            
            if (preg_match('/Bearer\s(\S+)/', $authHeader, $matches)) {
                $token = $matches[1];
                
                // 2. Aqui você faria a busca na tabela de SESSÕES:
                // SELECT id_usuario, data_expiracao FROM sessoes WHERE token_hash = ?
                
                // SIMULAÇÃO: Se fosse um token válido, busque os dados do usuário
                $id_usuario_simulado = 1; // ID recuperado da tabela de sessões
                
                // 3. Busca os dados do usuário pelo ID
                $stmt = $pdo->prepare("
                    SELECT u.id_usuario, p.nome_completo AS nome, pe.nome AS perfil
                    FROM usuario u
                    JOIN pessoa p ON p.id_pessoa = u.id_pessoa
                    JOIN usuario_perfil up ON up.id_usuario = u.id_usuario
                    JOIN perfil pe ON pe.id_perfil = up.id_perfil
                    WHERE u.id_usuario = ? AND u.ativo = 1
                ");
                $stmt->execute([$id_usuario_simulado]);
                $user = $stmt->fetch();
                
                if ($user) {
                    echo json_encode(["ok" => true, "usuario" => $user]);
                    exit;
                }
            }
            
            // Se o token estiver faltando, inválido, ou expirado
            http_response_code(401);
            echo json_encode(["erro" => "Sessão inválida ou expirada."]);
            
        } else {
            http_response_code(404);
            echo json_encode(["erro" => "Ação GET inválida."]);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["erro" => "Método não permitido."]);
}