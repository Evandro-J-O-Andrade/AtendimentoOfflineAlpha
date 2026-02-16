<?php
require_once __DIR__ . '/../utils.php';

$usuario = usuarioAutenticado();

// Perfis operacionais permitidos; ajuste conforme sua regra
// exigirAlgumPerfil(['RECEPCAO','TRIAGEM','CONSULTORIO','INTERNACAO','ADMIN']);

$method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

if ($method === 'GET') {
    $unidadeId = isset($_COOKIE['ctx_unidade_id']) ? (int)$_COOKIE['ctx_unidade_id'] : null;
    echo json_encode([
        'ok' => true,
        'usuario' => [
            'id_usuario' => $usuario['id_usuario'] ?? null,
            'login' => $usuario['login'] ?? null,
        ],
        'contexto' => [
            'unidade_id' => $unidadeId,
        ],
    ]);
    exit;
}

if ($method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $unidadeId = isset($input['unidade_id']) ? (int)$input['unidade_id'] : 0;

    if ($unidadeId <= 0) {
        http_response_code(400);
        echo json_encode(['ok' => false, 'erro' => 'unidade_id inválido']);
        exit;
    }

    // Cookie simples para manter contexto por 8 horas
    setcookie('ctx_unidade_id', (string)$unidadeId, [
        'expires' => time() + 8 * 3600,
        'path' => '/',
        'httponly' => false,
        'samesite' => 'Lax',
    ]);

    echo json_encode([
        'ok' => true,
        'mensagem' => 'Contexto unidade atualizado',
        'contexto' => [
            'unidade_id' => $unidadeId,
        ],
    ]);
    exit;
}

http_response_code(405);

echo json_encode(['ok' => false, 'erro' => 'Método não suportado']);