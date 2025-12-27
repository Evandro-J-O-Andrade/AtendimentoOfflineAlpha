<?php
require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../middleware.php';

header('Content-Type: application/json');

$pdo = getPDO();
$usuario = validarToken($pdo);

// validarToken já encerra com código 401/403 em caso de problema
// Retorna o objeto de usuário direto para manter compatibilidade com o cliente
echo json_encode($usuario);
