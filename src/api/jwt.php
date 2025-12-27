<?php
// Helper simples para JWT com HMAC SHA256.
// Usa a variável de ambiente JWT_SECRET se disponível, senão usa um valor padrão (troque em produção).

const JWT_DEFAULT_EXP = 3600; // 1 hora

function jwt_secret(): string {
    $s = getenv('JWT_SECRET');
    if ($s && strlen($s) > 16) return $s;
    // valor de desenvolvimento — altere no ambiente de produção
    return 'dev-secret-please-change-2025';
}

function base64url_encode(string $data): string {
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

function base64url_decode(string $data): string {
    $remainder = strlen($data) % 4;
    if ($remainder) {
        $padlen = 4 - $remainder;
        $data .= str_repeat('=', $padlen);
    }
    return base64_decode(strtr($data, '-_', '+/'));
}

function jwt_encode(array $payload, int $exp = JWT_DEFAULT_EXP): string {
    $header = ['alg' => 'HS256', 'typ' => 'JWT'];
    $iat = time();
    $payload['iat'] = $iat;
    $payload['exp'] = $iat + $exp;

    $b1 = base64url_encode(json_encode($header));
    $b2 = base64url_encode(json_encode($payload));
    $sig = hash_hmac('sha256', "$b1.$b2", jwt_secret(), true);
    $b3 = base64url_encode($sig);

    return "$b1.$b2.$b3";
}

/**
 * Decodifica e valida um JWT HMAC-SHA256.
 * Retorna o payload (array) em caso de sucesso ou false em caso de token inválido/expirado.
 */
function jwt_decode(string $token) {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return false;
    [$b1, $b2, $b3] = $parts;

    $sig = base64url_decode($b3);
    $expected = hash_hmac('sha256', "$b1.$b2", jwt_secret(), true);
    if (!hash_equals($expected, $sig)) return false;

    $payload_json = base64url_decode($b2);
    $payload = json_decode($payload_json, true);
    if (!$payload || !isset($payload['exp'])) return false;

    if ($payload['exp'] < time()) return false;

    return $payload;
}
