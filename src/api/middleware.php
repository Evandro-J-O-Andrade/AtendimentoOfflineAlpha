<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/jwt.php';

/**
 * Extrai o Bearer token do header Authorization.
 */
function getBearerToken(): ?string {
    $auth = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['REDIRECT_HTTP_AUTHORIZATION'] ?? '';
    if (!$auth) return null;

    if (preg_match('/Bearer\s+(\S+)/i', $auth, $m)) {
        return $m[1];
    }
    return null;
}

/**
 * Valida JWT e retorna array com usuario/perfis.
 * OBS: Aqui eu mantenho simples: valida assinatura e retorna payload.
 * Se você já consulta banco para verificar usuário ativo, mantenha isso aqui.
 */
function validarToken(PDO $pdo): array {
    $token = getBearerToken();
    if (!$token) {
        http_response_code(401);
        echo json_encode(['error' => 'Token ausente']);
        exit;
    }

    $payload = jwt_decode($token);
    if ($payload === false) {
        http_response_code(401);
        echo json_encode(['error' => 'Token inválido ou expirado']);
        exit;
    }

    $id_usuario = (int)($payload['id_usuario'] ?? 0);
    if ($id_usuario <= 0) {
        http_response_code(401);
        echo json_encode(['error' => 'Token sem id_usuario']);
        exit;
    }

    // Carrega usuário do banco (garante ativo)
    $stmt = $pdo->prepare("SELECT id_usuario, login, ativo FROM usuario WHERE id_usuario = ?");
    $stmt->execute([$id_usuario]);
    $u = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$u || (int)$u['ativo'] !== 1) {
        http_response_code(401);
        echo json_encode(['error' => 'Usuário inválido ou inativo']);
        exit;
    }

    // Perfis: preferir payload; se vier vazio, buscar na fonte da verdade (usuario_sistema)
    $perfis = $payload['perfis'] ?? [];
    if (!is_array($perfis) || count($perfis) === 0) {
        try {
            $st = $pdo->prepare(
                "SELECT DISTINCT p.nome\n" .
                "  FROM usuario_sistema us\n" .
                "  JOIN perfil p ON p.id_perfil = us.id_perfil\n" .
                " WHERE us.id_usuario = ? AND COALESCE(us.ativo,1)=1\n" .
                " ORDER BY p.nome"
            );
            $st->execute([$id_usuario]);
            $perfis = $st->fetchAll(PDO::FETCH_COLUMN) ?: [];
        } catch (Exception $e) {
            $perfis = [];
        }
    }

    // Normalização: uppercase/trim e remove vazios
    $perfisNorm = [];
    foreach ($perfis as $p) {
        $p = strtoupper(trim((string)$p));
        if ($p !== '') $perfisNorm[] = $p;
    }
    $perfisNorm = array_values(array_unique($perfisNorm));

    return [
        'id_usuario' => (int)$u['id_usuario'],
        'login'      => $u['login'],
        'ativo'      => (int)$u['ativo'],
        'perfis'     => $perfisNorm,
        // você pode anexar outros campos aqui, se quiser
    ];
}
