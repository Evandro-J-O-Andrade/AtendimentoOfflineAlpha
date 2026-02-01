<?php
require_once __DIR__ . '/../config.php';

class ChamadaController {
    private $pdo;
    public function __construct() {
        $this->pdo = getPDO();
    }
    public function chamarPaciente($id_ffa, $usuario_chamador) {
        try {
            $this->pdo->beginTransaction();
            $stmt = $this->pdo->prepare("UPDATE ffa SET status = 'CHAMANDO_MEDICO', layout = 'PAINEL_MEDICO', atualizado_em = NOW() WHERE id = ?");
            $stmt->execute([$id_ffa]);
            $stmt2 = $this->pdo->prepare("INSERT INTO auditoria_ffa (id_ffa, tipo_evento, acao, chamado_por, timestamp) VALUES (?, 'CHAMADA_MEDICA', 'Chamada manual', ?, NOW())");
            $stmt2->execute([$id_ffa, $usuario_chamador]);
            $this->pdo->commit();
            echo json_encode(["ok" => true, "data" => ["mensagem" => "Paciente {$id_ffa} chamado com sucesso"]]);
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) $this->pdo->rollBack();
            http_response_code(500);
            echo json_encode(["ok" => false, "error" => $e->getMessage()]);
        }
    }
}
