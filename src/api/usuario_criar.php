<?php
require "config.php";
$pdo = getPDO();

$data = json_decode(file_get_contents("php://input"), true);

// ATENÇÃO: A senha NUNCA deve ser inserida em texto plano
$senha_hash = password_hash($data['senha'], PASSWORD_DEFAULT);

try {
    $pdo->beginTransaction();

    // 1. Resolve ou cria a pessoa: aceita id_pessoa, ou usa nome/cpf/data_nasc/sexo para criar/buscar
    $id_pessoa = $data['id_pessoa'] ?? null;
    if (!$id_pessoa) {
        $stmt = $pdo->prepare("CALL sp_buscar_ou_criar_pessoa(:nome, :cpf, :cns, :data_nasc, :sexo, @p_id_pessoa)");
        $stmt->execute([
            ':nome' => $data['nome'] ?? null,
            ':cpf' => $data['cpf'] ?? null,
            ':cns' => $data['cns'] ?? null,
            ':data_nasc' => $data['data_nasc'] ?? null,
            ':sexo' => $data['sexo'] ?? null,
        ]);

        $row = $pdo->query("SELECT @p_id_pessoa AS id_pessoa")->fetch(PDO::FETCH_ASSOC);
        $id_pessoa = $row['id_pessoa'] ?? null;
        if (!$id_pessoa) {
            throw new Exception('Falha ao obter id_pessoa');
        }
    }

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

    // 3. Vincula os perfis (aceita id_perfil único para compatibilidade ou id_perfis array)
    $id_perfis = [];
    if (!empty($data['id_perfis']) && is_array($data['id_perfis'])) {
        $id_perfis = $data['id_perfis'];
    } elseif (!empty($data['id_perfil'])) {
        $id_perfis = [$data['id_perfil']];
    }

    if (count($id_perfis) > 0) {
        $stmt_perfil = $pdo->prepare("INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)");
        foreach ($id_perfis as $pid) {
            $stmt_perfil->execute([$id_usuario, (int)$pid]);
        }
    }

    $pdo->commit();
    echo json_encode(["ok" => true, "id_usuario" => $id_usuario]);

} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["erro" => "Falha ao criar usuário: " . $e->getMessage()]);
}