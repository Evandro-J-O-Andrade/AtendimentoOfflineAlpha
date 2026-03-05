const db = require("../config/database");

// Buscar prescrições de farmácia por termo (senha ou nome do paciente)
async function buscarPrescricoes(req, res) {
    try {
        const { termo } = req.query;
        
        if (!termo || termo.trim() === "") {
            return res.status(400).json({ error: "Termo de busca obrigatório" });
        }

        // Buscar senhas pelo número ou nome do paciente
        // A tabela senha usa 'codigo_visual' para o código visível
        let query = `
            SELECT DISTINCT
                s.id_senha AS id_senha,
                s.codigo_visual AS senha,
                s.id_atendimento,
                p.id AS id_paciente,
                p.nome AS nome_paciente,
                u.nome AS nome_medico,
                DATE_FORMAT(s.criado_em, '%d/%m/%Y %H:%i') AS data_senha
            FROM senha s
            JOIN paciente pac ON pac.id = s.id_paciente
            JOIN pessoa p ON p.id = pac.id_pessoa
            LEFT JOIN usuario u ON u.id_usuario = s.id_sessao_usuario
            WHERE s.cancelado = 0 
              AND s.id_atendimento IS NOT NULL
              AND (s.codigo_visual LIKE ? OR p.nome LIKE ?)
            ORDER BY s.criado_em DESC
            LIMIT 10
        `;
        
        const searchTerm = `%${termo}%`;
        const [senhas] = await db.execute(query, [searchTerm, searchTerm]);

        if (senhas.length === 0) {
            return res.json({ prescricoes: [] });
        }

        // Para cada senha, buscar os itens de prescrição da tabela correta
        const prescricoes = await Promise.all(senhas.map(async (senha) => {
            // Buscar prescrições da tabela atendimento_prescricao
            const [itens] = await db.execute(`
                SELECT 
                    ap.id AS id,
                    ap.medicamento,
                    ap.dose,
                    ap.via,
                    ap.frequencia,
                    ap.observacao,
                    ap.status AS item_status,
                    ap.data_prescricao AS criado_em
                FROM atendimento_prescricao ap
                WHERE ap.id_atendimento = ?
                  AND ap.status = 'ATIVO'
                ORDER BY ap.data_prescricao
            `, [senha.id_atendimento]);

            return {
                id: senha.id_senha,
                id_atendimento: senha.id_atendimento,
                senha: senha.senha,
                id_paciente: senha.id_paciente,
                nome_paciente: senha.nome_paciente,
                nome_medico: senha.nome_medico,
                data_senha: senha.data_senha,
                itens: itens.map(item => ({
                    ...item,
                    dosagem: item.dose,  // Mapeia dose para dosagem que o frontend espera
                    frequencia: item.frequencia,
                    dispensado: item.item_status === 'CONCLUIDO'
                }))
            };
        }));

        res.json({ prescricoes });

    } catch (error) {
        console.error("Erro ao buscar prescrições:", error);
        res.status(500).json({ error: "Erro ao buscar prescrições" });
    }
}

// Dispensar medicamento
async function dispensarMedicamento(req, res) {
    try {
        const { id_prescricao_item, lote } = req.body;
        const id_sessao = req.id_sessao;

        if (!id_prescricao_item) {
            return res.status(400).json({ error: "ID do item de prescrição obrigatório" });
        }

        // Buscar informações do item na tabela atendimento_prescricao
        const [itens] = await db.execute(`
            SELECT ap.*, s.id_senha 
            FROM atendimento_prescricao ap
            JOIN senha s ON s.id_atendimento = ap.id_atendimento
            WHERE ap.id = ?
        `, [id_prescricao_item]);

        if (itens.length === 0) {
            return res.status(404).json({ error: "Item de prescrição não encontrado" });
        }

        const item = itens[0];

        // Verificar se já foi dispensado
        if (item.status === 'CONCLUIDO') {
            return res.status(400).json({ error: "Item já foi dispensado" });
        }

        // Atualizar status do item para concluído
        await db.execute(`
            UPDATE atendimento_prescricao 
            SET status = 'CONCLUIDO'
            WHERE id = ?
        `, [id_prescricao_item]);

        // Registrar no log de dispensação usando a tabela correta
        // A dispensacao_medicacao precisa de id_farmaco, mas atendimento_prescricao tem o nome do medicamento
        // Vamos inserir com id_farmaco null por enquanto
        await db.execute(`
            INSERT INTO dispensacao_medicacao (
                id_ordem,
                id_item,
                id_farmaco,
                id_lote,
                quantidade,
                id_usuario_dispensador,
                data_hora,
                status,
                observacao
            ) VALUES (?, ?, NULL, NULL, 1, ?, NOW(6), 'ENTREGUE', ?)
        `, [item.id_atendimento, id_prescricao_item, id_sessao, `Dispensado: ${item.medicamento}`]);

        res.json({ 
            success: true, 
            message: "Medicamento dispensado com sucesso",
            id_prescricao_item
        });

    } catch (error) {
        console.error("Erro ao dispensar medicamento:", error);
        res.status(500).json({ error: "Erro ao dispensar medicamento" });
    }
}

// Finalizar dispensação de uma senha
async function finalizarDispensacao(req, res) {
    try {
        const { id } = req.params;
        const id_sessao = req.id_sessao;

        if (!id) {
            return res.status(400).json({ error: "ID da senha obrigatório" });
        }

        // Buscar o id_atendimento relacionado à senha
        const [senhas] = await db.execute(`
            SELECT id_atendimento FROM senha WHERE id_senha = ?
        `, [id]);

        if (senhas.length === 0) {
            return res.status(404).json({ error: "Senha não encontrada" });
        }

        const id_atendimento = senhas[0].id_atendimento;

        // Verificar se todos os itens foram dispensados
        const [itens] = await db.execute(`
            SELECT COUNT(*) AS total, 
                   SUM(CASE WHEN status = 'CONCLUIDO' THEN 1 ELSE 0 END) AS dispensados
            FROM atendimento_prescricao 
            WHERE id_atendimento = ? AND status != 'SUSPENSO'
        `, [id_atendimento]);

        if (itens.length === 0 || itens[0].total === 0) {
            return res.status(404).json({ error: "Prescrição não encontrada" });
        }

        // Atualizar status da senha - marcar como executada
        await db.execute(`
            UPDATE senha 
            SET executado_em = NOW(6)
            WHERE id_senha = ?
        `, [id]);

        res.json({ 
            success: true, 
            message: "Dispensação finalizada com sucesso"
        });

    } catch (error) {
        console.error("Erro ao finalizar dispensação:", error);
        res.status(500).json({ error: "Erro ao finalizar dispensação" });
    }
}

// Buscar histórico de dispensação
async function buscarHistorico(req, res) {
    try {
        const id_sessao = req.id_sessao;

        const [historico] = await db.execute(`
            SELECT 
                dm.id_dispensacao AS id,
                dm.data_hora AS criado_em,
                dm.observacao AS nome_medicamento,
                dm.quantidade,
                dm.status,
                s.codigo_visual AS senha,
                p.nome AS nome_paciente
            FROM dispensacao_medicacao dm
            JOIN senha s ON s.id_atendimento = dm.id_ordem
            JOIN paciente pac ON pac.id = s.id_paciente
            JOIN pessoa p ON p.id = pac.id_pessoa
            WHERE dm.id_usuario_dispensador = ?
            ORDER BY dm.data_hora DESC
            LIMIT 50
        `, [id_sessao]);

        res.json({ historico });

    } catch (error) {
        console.error("Erro ao buscar histórico:", error);
        res.status(500).json({ error: "Erro ao buscar histórico" });
    }
}

module.exports = {
    buscarPrescricoes,
    dispensarMedicamento,
    finalizarDispensacao,
    buscarHistorico
};
