<?php
function json_response($data, int $status = 200): void {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}
function bad_request(string $message, array $extra = []): void {
    json_response(array_merge(['message' => $message], $extra), 400);
}
function unauthorized(string $message = 'Não autorizado'): void {
    json_response(['message' => $message], 401);
}
function forbidden(string $message = 'Acesso negado'): void {
    json_response(['message' => $message], 403);
}
function server_error(string $message = 'Erro interno', $debug = null): void {
    $payload = ['message' => $message];
    if ($debug !== null) $payload['debug'] = $debug;
    json_response($payload, 500);
}
