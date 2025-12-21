<?php
require_once __DIR__ . '/config.php';
require_once __DIR__ . '/middleware.php';

/* =========================
   HEADERS
========================= */
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: http://localhost:5173");
header("Access-Control-Allow-Headers: Authorization, Content-Type");
header("Access-Control-Allow-Methods: GET, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

/* =========================
   CONEXÃO
========================= */
$pdo = getPDO();

/* =========================
   PROTEÇÃO
========================= */
$usuario = validarToken($pdo);

/* =========================
   EXEMPLO DE RETORNO
========================= */
echo json_encode([
    'ok' => true,
    'message' => 'Acesso autorizado',
    'usuario' => $usuario
]);
