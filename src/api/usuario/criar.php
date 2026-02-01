<?php
require __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$data = json_decode(file_get_contents('php://input'), true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "JSON inválido"]);
    exit;
}
if (empty($data['login']) || empty($data['senha'])) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "Campos obrigatórios ausentes: login e senha"]);
    exit;
}
$senha_hash = password_hash($data['senha'], PASSWORD_DEFAULT);
try {
    $pdo->beginTransaction();
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
        if (!$id_pessoa) throw new Exception('Falha ao obter id_pessoa');
    }
    $stmt_user = $pdo->prepare("INSERT INTO usuario (login, senha_hash, id_pessoa, ativo) VALUES (?, ?, ?, TRUE)");
    $stmt_user->execute([$data['login'], $senha_hash, $id_pessoa]);
    $id_usuario = $pdo->lastInsertId();
    $id_perfis = [];
    if (!empty($data['id_perfis']) && is_array($data['id_perfis'])) {
        $id_perfis = $data['id_perfis'];
    } elseif (!empty($data['id_perfil'])) {
        $id_perfis = [$data['id_perfil']];
    }
    if (count($id_perfis) > 0) {
        $stmt_perfil = $pdo->prepare("INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)");
        foreach ($id_perfis as $pid) $stmt_perfil->execute([$id_usuario, (int)$pid]);
    }
    $pdo->commit();
    echo json_encode(["ok" => true, "data" => ["id_usuario" => $id_usuario]]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao criar usuário: " . $e->getMessage()]);
}
