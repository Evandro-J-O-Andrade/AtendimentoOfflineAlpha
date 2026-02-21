// ========================================================
// Estoque Routes
// ========================================================
import express from 'express';
import { executeQuery, callProcedure } from '../config/mysql.js';

const router = express.Router();

/**
 * GET /api/estoque/saldo
 * Listar saldo de produtos em estoque
 */
router.get('/saldo', async (req, res) => {
  try {
    const saldos = await executeQuery(
      `SELECT el.id_lote, ep.id_produto, ep.nome, el.lote, el.validade,
              el.quantidade, el.quantidade_reservada, el.custo_unitario
       FROM estoque_lote el
       JOIN estoque_produto ep ON ep.id_produto = el.id_produto
       ORDER BY ep.nome, el.validade`
    );
    
    res.json({ success: true, saldos });
  } catch (error) {
    console.error('Erro ao listar saldo:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * GET /api/estoque/movimentos
 * Listar movimentos de estoque (append-only)
 */
router.get('/movimentos', async (req, res) => {
  try {
    const movimentos = await executeQuery(
      `SELECT em.id_movimento, em.tipo, em.origem, emi.id_produto,
              ep.nome, emi.quantidade, emi.valor_unitario, em.criado_em
       FROM estoque_movimento em
       JOIN estoque_movimento_item emi ON emi.id_movimento = em.id_movimento
       JOIN estoque_produto ep ON ep.id_produto = emi.id_produto
       ORDER BY em.criado_em DESC
       LIMIT 50`
    );
    
    res.json({ success: true, movimentos });
  } catch (error) {
    console.error('Erro ao listar movimentos:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * POST /api/estoque/movimento
 * Registrar novo movimento de estoque (append-only)
 * Body: { tipo, origem, id_produto, id_lote, qtd, valor_unitario? }
 */
router.post('/movimento', async (req, res) => {
  try {
    const { tipo, origem, id_estoque_local, id_produto, id_lote, quantidade, valor_unitario } = req.body;
    const idSessaoUsuario = req.user?.id_usuario;

    if (!tipo || !id_produto || !id_lote || !quantidade) {
      return res.status(400).json({
        success: false,
        error: 'Parâmetros obrigatórios: tipo, id_produto, id_lote, quantidade'
      });
    }

    // Registra movimento append-only
    const result = await executeQuery(
      `INSERT INTO estoque_movimento (id_estoque_local, tipo, origem, id_documento, id_sessao_usuario, criado_em)
       VALUES (?, ?, ?, NULL, ?, NOW())`,
      [id_estoque_local, tipo, origem, idSessaoUsuario]
    );

    const idMovimento = result.insertId;

    // Registra item do movimento
    await executeQuery(
      `INSERT INTO estoque_movimento_item (id_movimento, id_produto, id_lote, quantidade, valor_unitario, criado_em)
       VALUES (?, ?, ?, ?, ?, NOW())`,
      [idMovimento, id_produto, id_lote, quantidade, valor_unitario || null]
    );

    res.json({
      success: true,
      message: 'Movimento registrado (append-only)',
      id_movimento: idMovimento
    });
  } catch (error) {
    console.error('Erro ao registrar movimento:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

/**
 * GET /api/estoque/lotes/:idProduto
 * Listar lotes de um produto
 */
router.get('/lotes/:idProduto', async (req, res) => {
  try {
    const { idProduto } = req.params;
    
    const lotes = await executeQuery(
      `SELECT id_lote, lote, validade, quantidade, quantidade_reservada, custo_unitario
       FROM estoque_lote
       WHERE id_produto = ?
       ORDER BY validade ASC`,
      [idProduto]
    );
    
    res.json({ success: true, lotes });
  } catch (error) {
    console.error('Erro ao listar lotes:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

export default router;
