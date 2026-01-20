<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/utils.php';
header('Content-Type: application/json');

$pdo = getPDO();
$usuario = validarToken($pdo);

// Permitir apenas ADMIN (alias) ou SUPORTE
exigirAlgumPerfil(['ADMIN', 'SUPORTE']);

$data = json_decode(file_get_contents('php://input'), true);
if (empty($data['id_usuario'])) {
    http_response_code(400);
    echo json_encode(['error' => 'id_usuario é obrigatório']);
    exit;
}

try {
    $pdo->beginTransaction();

    $id_usuario = (int)$data['id_usuario'];
    $login = $data['login'] ?? null;
    $ativo = isset($data['ativo']) ? (bool)$data['ativo'] : null;
    $id_perfil = isset($data['id_perfil']) ? (int)$data['id_perfil'] : null; // opcional
    $nome = $data['nome'] ?? null;
    $senha = $data['senha'] ?? null; // opcional (reset)

    // Atualiza login/ativo
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

    // Atualiza senha se fornecida
    if (!empty($senha)) {
        $senha_hash = password_hash($senha, PASSWORD_DEFAULT);
        $stmt = $pdo->prepare('UPDATE usuario SET senha_hash = ? WHERE id_usuario = ?');
        $stmt->execute([$senha_hash, $id_usuario]);
    }

    // Atualiza nome na tabela pessoa
    if (!empty($nome)) {
        $stmt = $pdo->prepare('
            UPDATE pessoa p
            JOIN usuario u ON u.id_pessoa = p.id_pessoa
               SET p.nome_completo = ?
             WHERE u.id_usuario = ?
        ');
        $stmt->execute([$nome, $id_usuario]);
    }

    // Substitui perfis se foi informado (aceita id_perfis array para múltiplos)
    $id_perfis = [];
    if (isset($data['id_perfis']) && is_array($data['id_perfis'])) {
        $id_perfis = $data['id_perfis'];
    } elseif ($id_perfil !== null) {
        $id_perfis = [$id_perfil];
    }

    if ($id_perfis !== null && count($id_perfis) >= 0) {
        // remove perfis anteriores
        $stmt = $pdo->prepare('DELETE FROM usuario_perfil WHERE id_usuario = ?');
        $stmt->execute([$id_usuario]);

        if (count($id_perfis) > 0) {
            $stmt = $pdo->prepare('INSERT INTO usuario_perfil (id_usuario, id_perfil) VALUES (?, ?)');
            foreach ($id_perfis as $pid) {
                $stmt->execute([$id_usuario, (int)$pid]);
            }
        }
    }

    $pdo->commit();
    echo json_encode(['ok' => true]);
} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error' => 'Falha ao atualizar usuário', 'message' => $e->getMessage()]);
}
