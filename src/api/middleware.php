<?php
// api/middleware.php
require_once __DIR__ . '/config.php';

/**
 * Valida token enviado no header Authorization: Bearer <token>
 * Retorna dados do usuário autenticado
 * Encerra a execução se inválido
 */
function validarToken(PDO $pdo) {

    /* =========================
       HEADERS
    ========================= */
    header("Access-Control-Allow-Origin: http://localhost:5173");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
    header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    header("Content-Type: application/json; charset=UTF-8");

    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit;
    }

    /* =========================
       TOKEN
    ========================= */
    $headers = getallheaders();
    $auth = $headers['Authorization'] ?? $headers['authorization'] ?? '';

    if (!preg_match('/Bearer\s(\S+)/', $auth, $matches)) {
        http_response_code(401);
        echo json_encode(["message" => "Token não informado"]);
        exit;
    }

    $token = $matches[1];
    $payload = json_decode(base64_decode($token), true);

    if (!$payload || !isset($payload['id_usuario'], $payload['exp'])) {
        http_response_code(401);
        echo json_encode(["message" => "Token inválido"]);
        exit;
    }

    if ($payload['exp'] < time()) {
        http_response_code(401);
        echo json_encode(["message" => "Token expirado"]);
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
    $usuario = $stmt->fetch();

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
