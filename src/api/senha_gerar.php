<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

$pdo = getPDO();

$data = json_decode(file_get_contents('php://input'), true);
$origem = strtoupper(trim($data['origem'] ?? 'TOTEM')) === 'RECEPCAO' ? 'RECEPCAO' : 'TOTEM';

try {
    // Gera senha via procedure
    $stmt = $pdo->prepare("CALL sp_gerar_senha(:origem)");
    $stmt->execute([':origem' => $origem]);

    // Pega o id gerado
    $id = $pdo->lastInsertId();

    // Busca o número da senha
    $stmt2 = $pdo->prepare("SELECT id_senha, numero, origem, data_hora FROM senha WHERE id_senha = ?");
    $stmt2->execute([$id]);
    $senha = $stmt2->fetch(PDO::FETCH_ASSOC);

    if (!$senha) {
        http_response_code(500);
        echo json_encode(['error' => 'Falha ao recuperar senha gerada']);
        exit;
    }

    echo json_encode(['ok' => true, 'senha' => $senha]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Erro ao gerar senha', 'message' => $e->getMessage()]);
}
