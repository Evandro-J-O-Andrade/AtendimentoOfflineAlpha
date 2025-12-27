<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/jwt.php';

function validarToken(PDO $pdo): array {

    /* =========================
       HEADERS / CORS
    ========================= */
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Origin: http://prontoatendimento.local");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");

    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit;
    }

    /* =========================
       TOKEN
    ========================= */
    $headers = getallheaders();
    $auth = $headers['Authorization'] ?? $headers['authorization'] ?? '';

    if (!preg_match('/Bearer\s+(\S+)/', $auth, $matches)) {
        http_response_code(401);
        echo json_encode(["message" => "Token não informado"]);
        exit;
    }

    $token = $matches[1];

    // jwt_decode já valida assinatura e exp
    $payload = jwt_decode($token);

    if (!$payload || !isset($payload['id_usuario'])) {
        http_response_code(401);
        echo json_encode(["message" => "Token inválido ou expirado"]);
        exit;
    }

    /* =========================
       USUÁRIO
    ========================= */
    $stmt = $pdo->prepare("
        SELECT 
            u.id_usuario,
            u.login,
            p.nome_completo
        FROM usuario u
        JOIN pessoa p ON p.id_pessoa = u.id_pessoa
        WHERE u.id_usuario = ?
          AND u.ativo = 1
    ");
    $stmt->execute([$payload['id_usuario']]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$usuario) {
        http_response_code(401);
        echo json_encode(["message" => "Usuário inválido"]);
        exit;
    }

    /* =========================
       PERFIS
    ========================= */
    $stmt = $pdo->prepare("
        SELECT p.nome
        FROM usuario_perfil up
        JOIN perfil p ON p.id_perfil = up.id_perfil
        WHERE up.id_usuario = ?
    ");
    $stmt->execute([$usuario['id_usuario']]);
    $perfis = $stmt->fetchAll(PDO::FETCH_COLUMN);

    if (!$perfis) {
        http_response_code(403);
        echo json_encode(["message" => "Usuário sem perfil"]);
        exit;
    }

    /* =========================
       RETORNO
    ========================= */
    return [
        'id_usuario' => $usuario['id_usuario'],
        'login'      => $usuario['login'],
        'nome'       => $usuario['nome_completo'],
        'perfis'     => $perfis
    ];
}
