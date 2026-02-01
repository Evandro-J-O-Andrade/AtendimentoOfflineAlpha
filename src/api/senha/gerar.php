<?php
require __DIR__ . '/../config.php';
header('Content-Type: application/json; charset=utf-8');
$pdo = getPDO();
$data = json_decode(file_get_contents('php://input'), true);
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(["ok" => false, "error" => "JSON inválido"]);
    exit;
}
$origem = strtoupper(trim($data['origem'] ?? 'TOTEM')) === 'RECEPCAO' ? 'RECEPCAO' : 'TOTEM';
try {
    $stmt = $pdo->prepare("CALL sp_gerar_senha(:origem)");
    $stmt->execute([':origem' => $origem]);

    $id = $pdo->lastInsertId();
    if (!$id) {
        // Alguns ambientes retornam 0; tentar buscar pela última senha pela data/hora
        $stmt2 = $pdo->prepare("SELECT id_senha, numero, origem, data_hora FROM senha ORDER BY id_senha DESC LIMIT 1");
        $stmt2->execute();
        $senha = $stmt2->fetch(PDO::FETCH_ASSOC);
    } else {
        $stmt2 = $pdo->prepare("SELECT id_senha, numero, origem, data_hora FROM senha WHERE id_senha = ?");
        $stmt2->execute([$id]);
        $senha = $stmt2->fetch(PDO::FETCH_ASSOC);
    }

    if (!$senha) {
        http_response_code(500);
        echo json_encode(["ok" => false, "error" => "Falha ao recuperar senha gerada"]);
        exit;
    }

    echo json_encode(["ok" => true, "data" => $senha]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["ok" => false, "error" => "Erro ao gerar senha: " . $e->getMessage()]);
}
