<?php
require_once __DIR__ . '/../_core/bootstrap.php';

$usuario = validarToken($pdo);
$id_usuario = (int)($usuario['id_usuario'] ?? 0);

if (!$id_usuario) unauthorized();

try {
    $stmt = $pdo->prepare("
        SELECT s.id_sistema, s.nome
        FROM usuario_sistema us
        JOIN sistema s ON s.id_sistema = us.id_sistema
        WHERE us.id_usuario = ?
          AND us.ativo = 1
          AND s.ativo = 1
        GROUP BY s.id_sistema, s.nome
        ORDER BY s.nome
    ");
    $stmt->execute([$id_usuario]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    json_response($rows);
} catch (Throwable $e) {
    server_error('Falha ao listar sistemas', $e->getMessage());
}
