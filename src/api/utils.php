<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/middleware.php';

/* =========================
   CONEXÃO COM O BANCO
========================= */
$pdo = getPDO();

/* =========================
   PROTEÇÃO DA ROTA
========================= */
$usuario = validarToken($pdo);

/* =========================
   FUNÇÕES ÚTEIS DO SISTEMA
========================= */

/**
 * Retorna o usuário autenticado
 */
function usuarioAutenticado() {
    global $usuario;
    return $usuario;
}

/**
 * Verifica se o usuário possui um perfil específico
 */
function usuarioTemPerfil(string $perfil): bool {
    global $usuario;
    return in_array($perfil, $usuario['perfis'] ?? []);
}

/**
 * Força perfil específico (ex: ADMIN)
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
