<?php
function jwt_secret(): string {
    if (defined('JWT_SECRET') && JWT_SECRET) {
        return JWT_SECRET;
    }
    $s = getenv('JWT_SECRET');
    return $s ?: 'dev-secret-please-change-2025';
}

function base64url_encode($data) {
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

function base64url_decode($data) {
    $pad = 4 - (strlen($data) % 4);
    if ($pad < 4) $data .= str_repeat('=', $pad);
    return base64_decode(strtr($data, '-_', '+/'));
}

function jwt_encode(array $payload, int $exp = 3600) {
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

function jwt_decode(string $token) {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return false;
    [$b1, $b2, $b3] = $parts;
    $sig = base64url_decode($b3);
    $expected = hash_hmac('sha256', "$b1.$b2", jwt_secret(), true);
    if (!hash_equals($expected, $sig)) return false;
    $payload = json_decode(base64url_decode($b2), true);
    if (!$payload || !isset($payload['exp']) || $payload['exp'] < time()) return false;
    return $payload;
}
