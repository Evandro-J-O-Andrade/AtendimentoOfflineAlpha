<?php
require_once __DIR__ . '/config.php';

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

    $secret = JWT_SECRET; // definido no config.php

    $parts = explode('.', $token);
    if (count($parts) !== 3) {
        http_response_code(401);
        echo json_encode(['error' => 'Token inválido']);
        exit;
    }

    [$h64, $p64, $s64] = $parts;

    $sig = rtrim(strtr($s64, '-_', '+/'), '=');
    $payloadJson = base64_decode(strtr($p64, '-_', '+/'));
    $headerJson  = base64_decode(strtr($h64, '-_', '+/'));

    if (!$payloadJson || !$headerJson) {
        http_response_code(401);
        echo json_encode(['error' => 'Token inválido']);
        exit;
    }

    $calc = hash_hmac('sha256', "$h64.$p64", $secret, true);
    $calc64 = rtrim(strtr(base64_encode($calc), '+/', '-_'), '=');

    if (!hash_equals($calc64, $s64)) {
        http_response_code(401);
        echo json_encode(['error' => 'Assinatura inválida']);
        exit;
    }

    $payload = json_decode($payloadJson, true);
    if (!is_array($payload)) {
        http_response_code(401);
        echo json_encode(['error' => 'Payload inválido']);
        exit;
    }

    // exp
    if (isset($payload['exp']) && time() > (int)$payload['exp']) {
        http_response_code(401);
        echo json_encode(['error' => 'Token expirado']);
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

    // Perfis do payload (normaliza array)
    $perfis = $payload['perfis'] ?? [];
    if (!is_array($perfis)) $perfis = [];

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
