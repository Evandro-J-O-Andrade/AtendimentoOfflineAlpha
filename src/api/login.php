<?php
require "config.php";

$data = json_decode(file_get_contents("php://input"), true);

$stmt = $pdo->prepare("
    SELECT 
        u.id_usuario, 
        p.nome_completo AS nome, 
        pe.nome AS perfil
    FROM usuario u
    JOIN pessoa p ON p.id_pessoa = u.id_pessoa -- CORREÇÃO: Junta com 'pessoa'
    JOIN usuario_perfil up ON up.id_usuario = u.id_usuario
    JOIN perfil pe ON pe.id_perfil = up.id_perfil
    WHERE u.login = ? 
      AND u.ativo = 1
      -- ATENÇÃO: A VERIFICAÇÃO DE SENHA (HASH) DEVE SER ADICIONADA AQUI!
");

$stmt->execute([$data['login']]);
$user = $stmt->fetch();

if (!$user) {
    http_response_code(401);
    echo json_encode(["erro" => "Usuário inválido ou inativo"]);
    exit;
}

echo json_encode($user);