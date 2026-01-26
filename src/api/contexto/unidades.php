<?php
require_once __DIR__ . '/../_core/bootstrap.php';

$usuario = validarToken($pdo);

$id_sistema = isset($_GET['id_sistema']) ? (int)$_GET['id_sistema'] : 0;
if (!$id_sistema) bad_request('id_sistema é obrigatório');

try {
    // Unidades por sistema (se tabela unidade estiver populada)
    $stmt = $pdo->prepare("
        SELECT id_unidade, nome
        FROM unidade
        WHERE ativo = 1
          AND id_sistema = ?
        ORDER BY nome
    ");
    $stmt->execute([$id_sistema]);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    json_response($rows);
} catch (Throwable $e) {
    // Se a tabela unidade existir mas schema diferente, não quebra o front: retorna vazio.
    json_response([]);
}
