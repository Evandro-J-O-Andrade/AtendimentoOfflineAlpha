<?php
require "config.php";

$data = json_decode(file_get_contents("php://input"), true);

try {
    // A procedure sp_abertura_recepcao encapsula toda a lógica de negócio
    $stmt = $pdo->prepare("
        CALL sp_abertura_recepcao(
            :nome, :cpf, :cns, :data_nascimento, :sexo, 
            :tipo, :chegada, :prioridade, :motivo, :destino, :usuario_id
        )
    ");
    
    // ATENÇÃO: Os dados devem vir do frontend para a chamada da SP
    $stmt->execute([
        ':nome' => $data['nome_completo'],
        ':cpf' => $data['cpf'],
        ':cns' => $data['cns'],
        ':data_nascimento' => $data['data_nascimento'],
        ':sexo' => $data['sexo'],
        ':tipo' => $data['tipo_atendimento'],
        ':chegada' => $data['meio_chegada'],
        ':prioridade' => $data['prioridade'],
        ':motivo' => $data['motivo_procura'],
        ':destino' => $data['destino_inicial'],
        ':usuario_id' => $data['id_usuario_logado'] 
    ]);

    echo json_encode(["ok" => true, "mensagem" => "Atendimento aberto com sucesso."]);

} catch (PDOException $e) {
    http_response_code(500);
    // Erros de permissão ou chave duplicada serão reportados aqui.
    echo json_encode(["erro" => "Falha ao abrir atendimento: " . $e->getMessage()]);
}