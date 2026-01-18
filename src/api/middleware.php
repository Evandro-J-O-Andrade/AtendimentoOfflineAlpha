<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/jwt.php';

function validarToken(PDO $pdo): array {
    $headers = getallheaders();
    $auth = $headers['Authorization'] ?? $headers['authorization'] ?? '';

    if (!preg_match('/Bearer\s+(\S+)/', $auth, $matches)) {
        http_response_code(401);
        echo json_encode(["message" => "Token não informado"]);
        exit;
    }

    $payload = jwt_decode($matches[1]);
    if (!$payload || !isset($payload['id_usuario'])) {
        http_response_code(401);
        echo json_encode(["message" => "Token inválido ou expirado"]);
        exit;
    }

    $stmt = $pdo->prepare("
        SELECT u.id_usuario, u.login, p.nome_completo
        FROM usuario u
        JOIN pessoa p ON p.id_pessoa = u.id_pessoa
        WHERE u.id_usuario = ? AND u.ativo = 1
    ");
    $stmt->execute([$payload['id_usuario']]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$usuario) {
        http_response_code(401);
        echo json_encode(["message" => "Usuário inválido"]);
        exit;
    }

    // PERFIS
    $stmt = $pdo->prepare("
        SELECT p.nome
        FROM usuario_perfil up
        JOIN perfil p ON p.id_perfil = up.id_perfil
        WHERE up.id_usuario = ?
    ");
    $stmt->execute([$usuario['id_usuario']]);
    $perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

    // MASTER → ADMIN
    if (in_array('MASTER', $perfis) && !in_array('ADMIN', $perfis)) {
        $perfis[] = 'ADMIN';
    }

    if (!$perfis) {
        http_response_code(403);
        echo json_encode(["message" => "Usuário sem perfil"]);
        exit;
    }

    return [
        'id_usuario' => $usuario['id_usuario'],
        'login'      => $usuario['login'],
        'nome'       => $usuario['nome_completo'],
        'perfis'     => $perfis
    ];
}
