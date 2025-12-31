<?php
require_once __DIR__ . '/../config.php';

class ChamadaController {

    private $pdo;

    public function __construct() {
        $this->pdo = getPDO();
    }

    /**
     * Chama manualmente um paciente
     * Recebe:
     * - id_ffa
     * - usuario_chamador
     */
    public function chamarPaciente($id_ffa, $usuario_chamador) {
        try {
            // Atualiza status da FFA
            $stmt = $this->pdo->prepare("
                UPDATE ffa
                SET status = 'CHAMANDO_MEDICO',
                    layout = 'PAINEL_MEDICO',
                    atualizado_em = NOW()
                WHERE id = ?
            ");
            $stmt->execute([$id_ffa]);

            // Registra auditoria
            $stmt2 = $this->pdo->prepare("
                INSERT INTO auditoria_ffa (id_ffa, tipo_evento, acao, chamado_por, timestamp)
                VALUES (?, 'CHAMADA_MEDICA', 'Chamada manual', ?, NOW())
            ");
            $stmt2->execute([$id_ffa, $usuario_chamador]);

            echo json_encode([
                'status' => 'ok',
                'mensagem' => "Paciente {$id_ffa} chamado com sucesso"
            ]);

        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode(['erro' => $e->getMessage()]);
        }
    }
}
