<?php
require __DIR__ . '/../config.php';
require __DIR__ . '/../middleware.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$usuario = validarToken($pdo);
if (!usuarioTemPerfil($pdo, 'ADMIN', $usuario['id_usuario']) && !usuarioTemPerfil($pdo, 'SUPORTE', $usuario['id_usuario'])) {
    http_response_code(403);
    echo json_encode(["ok" => false, "error" => "Acesso negado"]);
    exit;
}
$data = json_decode(file_get_contents('php://input'), true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "JSON inválido"]);
    exit;
}
if (empty($data['id_usuario'])) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "id_usuario é obrigatório"]);
    exit;
}
try {
    $pdo->beginTransaction();
    $id_usuario = (int)$data['id_usuario'];
    $login = $data['login'] ?? null;
    $ativo = isset($data['ativo']) ? (bool)$data['ativo'] : null;
    $nome = $data['nome'] ?? null;
    $senha = $data['senha'] ?? null;
    $updates = [];
    $params = [];
    if ($login !== null) {
        $updates[] = 'login = :login';
        $params[':login'] = $login;
    }
    if ($ativo !== null) {
        $updates[] = 'ativo = :ativo';
        $params[':ativo'] = $ativo ? 1 : 0;
    }
    if (!empty($updates)) {
        $params[':id_usuario'] = $id_usuario;
        $sql = 'UPDATE usuario SET ' . implode(', ', $updates) . ' WHERE id_usuario = :id_usuario';
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
    }
    if (!empty($senha)) {
        $senha_hash = password_hash($senha, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare('UPDATE usuario SET senha_hash = ? WHERE id_usuario = ?');
        $stmt->execute([$senha_hash, $id_usuario]);
    }
    if (!empty($nome)) {
        $stmt = $pdo->prepare('UPDATE pessoa p JOIN usuario u ON u.id_pessoa = p.id_pessoa SET p.nome_completo = ? WHERE u.id_usuario = ?');
        $stmt->execute([$nome, $id_usuario]);
    }
    $id_perfis = [];
    if (isset($data['id_perfis']) && is_array($data['id_perfis'])) {
        $id_perfis = $data['id_perfis'];
    } elseif (isset($data['id_perfil'])) {
        $id_perfis = [$data['id_perfil']];
    }
    if ($id_perfis !== null && count($id_perfis) >= 0) {
        $stmt = $pdo->prepare('DELETE FROM usuario_perfil WHERE id_usuario = ?');
        $stmt->execute([$id_usuario]);
        if (count($id_perfis) > 0) {
            $stmt = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');
            foreach ($id_perfis as $pid) $stmt->execute([$id_usuario, (int)$pid]);
        }
    }
    $pdo->commit();
    echo json_encode(["ok" => true, "data" => ["mensagem" => "Usuário atualizado com sucesso"]]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Falha ao atualizar usuário: " . $e->getMessage()]);
}
