<?php
require_once __DIR__ . '/../_core/bootstrap.php';

$usuario = validarToken($pdo);

try {
    // Funciona tanto no schema correto (la.id_unidade -> unidade) quanto no schema atual (fk errado):
    // - Se o join com unidade falhar, u.id_sistema vem NULL e usamos la.id_unidade como fallback.
    $sql = "
        SELECT
          la.id_local,
          la.nome,
          la.tipo,
          la.ativo,
          la.id_unidade,
          COALESCE(u.id_sistema, la.id_unidade) AS id_sistema
        FROM local_atendimento la
        LEFT JOIN unidade u ON u.id_unidade = la.id_unidade
        WHERE la.ativo = 1
        ORDER BY la.nome
    ";

    $stmt = $pdo->query($sql);
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
    json_response($rows);
} catch (Throwable $e) {
    server_error('Falha ao listar locais', $e->getMessage());
}
