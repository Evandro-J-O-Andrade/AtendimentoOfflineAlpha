<?php
require_once __DIR__ . '/../config.php';

class FilaController {

    private $pdo;

    public function __construct() {
        $this->pdo = getPDO();
    }

    /**
     * Retorna próximo paciente da fila, respeitando:
     * - Classificação Manchester
     * - Score de prioridade social
     * - Ordem de chegada (criado_em)
     */
    public function proximoPaciente() {
        try {
            $stmt = $this->pdo->query("
                SELECT f.id, f.gpat, f.id_paciente, p.nome_completo, f.classificacao_manchester,
                       pl.tipo_plantao, pl.nome_medico,
                       fs.prioridade_social, f.criado_em
                FROM ffa f
                JOIN pessoa p ON f.id_paciente = p.id_pessoa
                LEFT JOIN plantao pl 
                    ON NOW() BETWEEN pl.inicio_plantao AND pl.fim_plantao
                    AND pl.ativo = 1
                LEFT JOIN fila_senha fs ON fs.id_ffa = f.id
                WHERE f.status = 'AGUARDANDO_CHAMADA_MEDICO'
                ORDER BY
                    FIELD(f.classificacao_manchester,'VERMELHO','LARANJA','AMARELO','VERDE','AZUL'),
                    fs.prioridade_social DESC,
                    f.criado_em
                LIMIT 1
            ");

            $paciente = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$paciente) {
                http_response_code(204);
                echo json_encode(['mensagem' => 'Nenhum paciente aguardando']);
                return;
            }

            echo json_encode($paciente);

        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode(['erro' => $e->getMessage()]);
        }
    }
}
