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
$nome = $data['nome_completo'] ?? null;
$cpf = $data['cpf'] ?? null;
$cns = $data['cns'] ?? null;
$data_nascimento = $data['data_nascimento'] ?? null;
$sexo = $data['sexo'] ?? null;
$id_senha = $data['id_senha'] ?? null;
$id_local = $data['id_local'] ?? 1;
$id_especialidade = $data['id_especialidade'] ?? null;
$tipo = $data['tipo_atendimento'] ?? 'CLINICO';
$chegada = $data['meio_chegada'] ?? 'MEIOS_PROPRIOS';
$prioridade = isset($data['prioridade']) && $data['prioridade'] !== '' ? strtoupper($data['prioridade']) : null;
$motivo = $data['motivo_procura'] ?? '';
$destino = $data['destino_inicial'] ?? 'TRIAGEM';
$id_usuario = $data['id_usuario_logado'] ?? null;
if (!$id_usuario) {
    http_response_code(400);
    echo json_encode(['ok' => false, 'error' => 'id_usuario_logado é obrigatório']);
    exit;
}
try {
    $pdo->beginTransaction();
    if (empty($id_senha)) {
        $stmt = $pdo->prepare("CALL sp_gerar_senha(:origem)");
        $stmt->execute([':origem' => 'RECEPCAO']);
        $id_senha = $pdo->lastInsertId();
    }
    $stmt = $pdo->prepare("CALL sp_buscar_ou_criar_pessoa(:nome, :cpf, :cns, :data_nasc, :sexo, @p_id_pessoa)");
    $stmt->execute([
        ':nome' => $nome,
        ':cpf' => $cpf,
        ':cns' => $cns,
        ':data_nasc' => $data_nascimento,
        ':sexo' => $sexo,
    ]);
    $row = $pdo->query("SELECT @p_id_pessoa AS id_pessoa")->fetch(PDO::FETCH_ASSOC);
    $id_pessoa = $row['id_pessoa'] ?? null;
    if (!$id_pessoa) throw new Exception('Falha ao obter id_pessoa');
    $stmt = $pdo->prepare("CALL sp_abre_atendimento(:id_pessoa, :id_senha, :id_local, :id_especialidade)");
    $stmt->execute([
        ':id_pessoa' => $id_pessoa,
        ':id_senha' => $id_senha,
        ':id_local' => $id_local,
        ':id_especialidade' => $id_especialidade
    ]);
    $id_atendimento = $pdo->lastInsertId();
    $stmt = $pdo->prepare("CALL sp_registrar_recepcao(:id_atendimento, :tipo, :chegada, :prioridade, :motivo, :destino, :usuario)");
    $stmt->execute([
        ':id_atendimento' => $id_atendimento,
        ':tipo' => $tipo,
        ':chegada' => $chegada,
        ':prioridade' => $prioridade,
        ':motivo' => $motivo,
        ':destino' => $destino,
        ':usuario' => $id_usuario
    ]);
    $pdo->commit();
    echo json_encode(['ok' => true, 'data' => ['id_senha' => $id_senha, 'id_atendimento' => $id_atendimento]]);
} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => 'Erro ao abrir atendimento: ' . $e->getMessage()]);
} catch (Exception $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['ok' => false, 'error' => $e->getMessage()]);
}
