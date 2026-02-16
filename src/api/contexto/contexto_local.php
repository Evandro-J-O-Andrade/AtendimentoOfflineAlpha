<?php
require_once __DIR__ . '/../utils.php';

$usuario = usuarioAutenticado();

// Perfis operacionais permitidos; ajuste conforme sua regra
// exigirAlgumPerfil(['RECEPCAO','TRIAGEM','CONSULTORIO','INTERNACAO','ADMIN']);

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    $localId = isset($_COOKIE['ctx_local_id']) ? (int)$_COOKIE['ctx_local_id'] : null;
    echo json_encode([
        'ok' => true,
        'usuario' => [
            'id_usuario' => $usuario['id_usuario'] ?? null,
            'login' => $usuario['login'] ?? null,
        ],
        'contexto' => [
            'local_id' => $localId,
        ],
    ]);
    exit;
}

if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $localId = isset($input['local_id']) ? (int)$input['local_id'] : 0;

    if ($localId <= 0) {
        http_response_code(400);
        echo json_encode(['ok' => false, 'erro' => 'local_id inválido']);
        exit;
    }

    // Cookie simples para manter contexto por 8 horas
    setcookie('ctx_local_id', (string)$localId, [
        'expires' => time() + 8 * 3600,
        'path' => '/',
        'httponly' => false,
        'samesite' => 'Lax',
    ]);

    echo json_encode([
        'ok' => true,
        'mensagem' => 'Contexto local atualizado',
        'contexto' => [
            'local_id' => $localId,
        ],
    ]);
    exit;
}

http_response_code(405);

echo json_encode(['ok' => false, 'erro' => 'Método não suportado']);