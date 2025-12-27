<?php
require_once __DIR__ . '/config.php';
header('Content-Type: application/json');

$pdo = getPDO();
$data = json_decode(file_get_contents('php://input'), true);

// Campos esperados (alguns são opcionais)
$nome = $data['nome_completo'] ?? null;
$cpf = $data['cpf'] ?? null;
$cns = $data['cns'] ?? null;
$data_nascimento = $data['data_nascimento'] ?? null;
$sexo = $data['sexo'] ?? null;
$id_senha = $data['id_senha'] ?? null; // se vier do Totem
$id_local = $data['id_local'] ?? 1; // default: recepção
$id_especialidade = $data['id_especialidade'] ?? null;
$tipo = $data['tipo_atendimento'] ?? 'CLINICO';
$chegada = $data['meio_chegada'] ?? 'MEIOS_PROPRIOS';
// Prioridade: se o frontend enviar explicitamente, usamos; caso contrário passamos NULL e o banco decide
$prioridade = isset($data['prioridade']) && $data['prioridade'] !== '' ? strtoupper($data['prioridade']) : null;
$motivo = $data['motivo_procura'] ?? '';
$destino = $data['destino_inicial'] ?? 'TRIAGEM';
$id_usuario = $data['id_usuario_logado'] ?? null;

if (!$id_usuario) {
    http_response_code(400);
    echo json_encode(['error' => 'id_usuario_logado é obrigatório']);
    exit;
}

try {
    $pdo->beginTransaction();

    // Se não veio id_senha, gera uma de RECEPCAO
    if (empty($id_senha)) {
        $stmt = $pdo->prepare("CALL sp_gerar_senha(:origem)");
        $stmt->execute([':origem' => 'RECEPCAO']);
        $id_senha = $pdo->lastInsertId();
    }

    // Busca ou cria pessoa usando SP (usa variável de sessão para OUT)
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

    if (!$id_pessoa) {
        throw new Exception('Falha ao obter id_pessoa');
    }

    // Abre atendimento
    $stmt = $pdo->prepare("CALL sp_abre_atendimento(:id_pessoa, :id_senha, :id_local, :id_especialidade)");
    $stmt->execute([
        ':id_pessoa' => $id_pessoa,
        ':id_senha' => $id_senha,
        ':id_local' => $id_local,
        ':id_especialidade' => $id_especialidade
    ]);

    $id_atendimento = $pdo->lastInsertId();

    // Registra informações da recepção
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

    echo json_encode([
        'ok' => true,
        'id_senha' => $id_senha,
        'id_atendimento' => $id_atendimento
    ]);
} catch (PDOException $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error' => 'Erro ao abrir atendimento', 'message' => $e->getMessage()]);
} catch (Exception $e) {
    $pdo->rollBack();
    http_response_code(500);
    echo json_encode(['error' => 'Erro', 'message' => $e->getMessage()]);
}
