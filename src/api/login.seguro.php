<?php
// login_seguro.php - Ponto de entrada crucial do sistema
require "config.php"; // Assume config.php configura $pdo

header("Content-Type: application/json; charset=UTF-8");

$data = json_decode(file_get_contents("php://input"), true);
$login = $data['login'] ?? '';
$senha_digitada = $data['senha'] ?? '';

if (empty($login) || empty($senha_digitada)) {
    http_response_code(400);
    echo json_encode(["erro" => "Login e senha são obrigatórios."]);
    exit;
}

$stmt = $pdo->prepare("
    SELECT 
        u.id_usuario, 
        u.senha_hash, 
        p.nome_completo AS nome, 
        pe.nome AS perfil
    FROM usuario u
    JOIN pessoa p ON p.id_pessoa = u.id_pessoa
    JOIN usuario_perfil up ON up.id_usuario = u.id_usuario
    JOIN perfil pe ON pe.id_perfil = up.id_perfil
    WHERE u.login = ? 
      AND u.ativo = 1
");

$stmt->execute([$login]);
$user = $stmt->fetch();

if (!$user) {
    // Retorna mensagem genérica de erro (segurança)
    http_response_code(401);
    echo json_encode(["erro" => "Credenciais inválidas."]);
    exit;
}

// VALIDAÇÃO CRÍTICA: Verifica a senha criptografada
if (password_verify($senha_digitada, $user['senha_hash'])) {
    
    // A SENHA É VÁLIDA. Remove o hash antes de enviar.
    unset($user['senha_hash']); 
    
    // GERAÇÃO DE TOKEN SIMPLES: Em produção, substitua por JWT (JSON Web Token)
    // Este token deve ser enviado de volta no header de TODAS as requisições.
    $token_de_sessao = hash('sha256', microtime() . $user['id_usuario'] . $login); 

    echo json_encode([
        "ok" => true,
        "token" => $token_de_sessao, 
        "usuario" => $user
    ]);

} else {
    // Senha incorreta
    http_response_code(401);
    echo json_encode(["erro" => "Credenciais inválidas."]);
}