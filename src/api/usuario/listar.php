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
try {
    $sql = "SELECT u.id_usuario, u.login, u.ativo, p.nome_completo, u.id_pessoa, GROUP_CONCAT(pe.nome) AS perfis, GROUP_CONCAT(up.id_perfil) AS perfis_ids FROM usuario u LEFT JOIN pessoa p ON p.id_pessoa = u.id_pessoa LEFT JOIN usuario_perfil up ON up.id_usuario = u.id_usuario LEFT JOIN perfil pe ON pe.id_perfil = up.id_perfil GROUP BY u.id_usuario ORDER BY u.id_usuario DESC";
    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    foreach ($rows as &$r) {
        $r['perfis'] = $r['perfis'] ? explode(',', $r['perfis']) : [];
        $r['perfis_ids'] = $r['perfis_ids'] ? array_map('intval', explode(',', $r['perfis_ids'])) : [];
    }
    echo json_encode(["ok" => true, "data" => $rows]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Erro ao listar usuários: " . $e->getMessage()]);
}
