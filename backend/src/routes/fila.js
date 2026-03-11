const express = require("express");
const router = express.Router();
const pool = require("../config/database");
const { verifyToken } = require("../middlewares/authMiddleware");

/**
 * Retorna a fila atual de pacientes de um local
 * GET /api/fila/atual?id_local_operacional=1
 */
router.get("/atual", verifyToken, async (req, res) => {
  const { id_local_operacional } = req.query;
  const id_usuario = req.user.id_usuario;

  let conn;
  try {
    conn = await pool.getConnection();

    // Buscar fila de pacientes (FFA) do local
    const [fila] = await conn.execute(
      `SELECT f.id_ffa, f.nome_paciente, f.status, f.urgencia, f.data_chegada, 
              f.id_fila_operacional, fo.nome as fila_nome
       FROM ffa f
       JOIN fila_operacional fo ON fo.id_fila_operacional = f.id_fila_operacional
       WHERE f.id_local_operacional = ? AND f.ativo = 1
       ORDER BY f.urgencia DESC, f.data_chegada ASC`,
      [id_local_operacional]
    );

    res.json(fila);

  } catch (err) {
    console.error("Erro ao buscar fila:", err);
    res.status(500).json({ error: "ERRO_INTERNO" });
  } finally {
    if (conn) conn.release();
  }
});

/**
 * Retorna as filas operacionais disponíveis
 * GET /api/fila/lista?id_unidade=1
 */
router.get("/lista", verifyToken, async (req, res) => {
  const { id_unidade, id_local_operacional } = req.query;

  let conn;
  try {
    conn = await pool.getConnection();

    let query = "SELECT id_fila_operacional, nome, ativo FROM fila_operacional WHERE 1=1";
    const params = [];

    if (id_unidade) {
      query += " AND id_unidade = ?";
      params.push(id_unidade);
    }

    if (id_local_operacional) {
      query += " AND id_local_operacional = ?";
      params.push(id_local_operacional);
    }

    query += " ORDER BY nome";

    const [filas] = await conn.execute(query, params);

    res.json(filas);

  } catch (err) {
    console.error("Erro ao buscar filas:", err);
    res.status(500).json({ error: "ERRO_INTERNO" });
  } finally {
    if (conn) conn.release();
  }
});

module.exports = router;
