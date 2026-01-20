<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/middleware.php';

header('Content-Type: application/json');

$pdo = getPDO();
$usuario = validarToken($pdo);

/**
 * Retorna o usuário autenticado
 */
function usuarioAutenticado() {
    global $usuario;
    return $usuario;
}

/**
 * Verifica se o usuário possui um perfil específico (com alias).
 * ADMIN => ADMIN_MASTER ou MASTER
 */
function usuarioTemPerfil(string $perfil): bool {
    global $usuario;

    $perfisUsuario = $usuario['perfis'] ?? [];
    if (!is_array($perfisUsuario)) $perfisUsuario = [];

    $perfil = strtoupper(trim($perfil));

    // Aliases para compatibilidade
    $aliases = [
        'ADMIN' => ['ADMIN_MASTER', 'MASTER'],
    ];

    // Se pediram alias, aceita qualquer equivalente
    if (isset($aliases[$perfil])) {
        foreach ($aliases[$perfil] as $p) {
            if (in_array($p, $perfisUsuario, true)) return true;
        }
        return false;
    }

    // Match exato
    return in_array($perfil, $perfisUsuario, true);
}

/**
 * True se tiver qualquer perfil de uma lista
 */
function usuarioTemAlgumPerfil(array $perfisPermitidos): bool {
    foreach ($perfisPermitidos as $p) {
        if (usuarioTemPerfil((string)$p)) return true;
    }
    return false;
}

/**
 * Força perfil específico
 */
function exigirPerfil(string $perfil) {
    if (!usuarioTemPerfil($perfil)) {
        http_response_code(403);
        echo json_encode([
            'erro' => 'Acesso negado',
            'mensagem' => "Perfil '$perfil' necessário"
        ]);
        exit;
    }
}

/**
 * Força pelo menos um perfil de uma lista
 */
function exigirAlgumPerfil(array $perfis) {
    if (!usuarioTemAlgumPerfil($perfis)) {
        http_response_code(403);
        echo json_encode([
            'erro' => 'Acesso negado',
            'mensagem' => "Um destes perfis é necessário: " . implode(', ', $perfis)
        ]);
        exit;
    }
}
