<?php
require "config.php";

$data = json_decode(file_get_contents("php://input"), true);

// ATENÇÃO: A senha NUNCA deve ser inserida em texto plano
$senha_hash = password_hash($data['senha'], PASSWORD_DEFAULT);

try {
    $pdo->beginTransaction();

    // 1. Insere o registro na tabela pessoa (se não existir, ou se for um novo cadastro)
    // Para simplificar, vamos assumir que id_pessoa já foi criado ou é passado.
    $id_pessoa = $data['id_pessoa']; 

    // 2. Insere na tabela usuario
    $stmt_user = $pdo->prepare("
        INSERT INTO usuario (login, senha_hash, id_pessoa, ativo)
        VALUES (?, ?, ?, TRUE)
    ");
    $stmt_user->execute([
        $data['login'],
        $senha_hash,
        $id_pessoa
    ]);
    $id_usuario = $pdo->lastInsertId();

    // 3. Vincula o perfil
    $stmt_perfil = $pdo->prepare("
        INSERT INTO usuario_perfil (id_usuario, id_perfil)
        VALUES (?, ?)
    ");
    $stmt_perfil->execute([$id_usuario, $data['id_perfil']]);

    $pdo->commit();
    echo json_encode(["ok" => true, "id_usuario" => $id_usuario]);

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao criar usuário: " . $e->getMessage()]);
}