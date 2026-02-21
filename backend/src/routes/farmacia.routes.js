// ========================================================
// Farmácia Routes
// ========================================================
import express from 'express';
import { executeQuery, callProcedure } from '../config/mysql.js';

const router = express.Router();

/**
 * GET /api/farmacia/dispensacoes
 * Listar dispensações
 */
router.get('/dispensacoes', async (req, res) => {
  try {
    const dispensacoes = await executeQuery(
      `SELECT fd.id_dispensacao, fd.id_receita, fd.tipo, fd.status, 
              fd.primeira_baixa_em, fd.segunda_baixa_em
       FROM farm_dispensacao fd
       ORDER BY fd.criado_em DESC
       LIMIT 20`
    );
    
    res.json({ success: true, dispensacoes });
  } catch (error) {
    console.error('Erro ao listar dispensações:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * POST /api/farmacia/dispensacao
 * Registrar nova dispensação
 * Body: { id_receita, id_produto, id_lote, qtd }
 */
router.post('/dispensacao', async (req, res) => {
  try {
    const { id_receita, id_produto, id_lote, id_estoque_local, quantidade } = req.body;
    const idSessaoUsuario = req.user?.id_usuario;

    if (!id_receita || !id_produto || !id_lote || !quantidade) {
      return res.status(400).json({
        success: false,
        error: 'Parâmetros obrigatórios: id_receita, id_produto, id_lote, quantidade'
      });
    }

    // Chama procedure sp_farm_dispensacao_registrar
    const result = await callProcedure('sp_farm_dispensacao_registrar', [
      idSessaoUsuario,
      id_receita,
      id_produto,
      id_lote,
      id_estoque_local,
      quantidade,
      null // observacao
    ]);

    res.json({
      success: true,
      message: 'Dispensação registrada',
      result
    });
  } catch (error) {
    console.error('Erro ao registrar dispensação:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * GET /api/farmacia/reservas
 * Listar reservas ativas
 */
router.get('/reservas', async (req, res) => {
  try {
    const reservas = await executeQuery(
      `SELECT er.id_reserva, er.id_produto, er.id_lote, er.quantidade, 
              er.status, er.criado_em
       FROM estoque_reserva er
       WHERE er.status = 'ATIVA'
       ORDER BY er.criado_em DESC`
    );
    
    res.json({ success: true, reservas });
  } catch (error) {
    console.error('Erro ao listar reservas:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * POST /api/farmacia/confirmar-reserva
 * Confirmar reserva (dupla baixa)
 * Body: { id_reserva, id_usuario_confirmador }
 */
router.post('/confirmar-reserva', async (req, res) => {
  try {
    const { id_reserva, id_usuario_confirmador } = req.body;
    const idSessaoUsuario = req.user?.id_usuario;

    if (!id_reserva || !id_usuario_confirmador) {
      return res.status(400).json({
        success: false,
        error: 'Parâmetros obrigatórios: id_reserva, id_usuario_confirmador'
      });
    }

    // Chama procedure sp_farm_reserva_confirmar
    const result = await callProcedure('sp_farm_reserva_confirmar', [
      idSessaoUsuario,
      id_reserva,
      id_usuario_confirmador,
      null // observacao
    ]);

    res.json({
      success: true,
      message: 'Reserva confirmada',
      result
    });
  } catch (error) {
    console.error('Erro ao confirmar reserva:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;
