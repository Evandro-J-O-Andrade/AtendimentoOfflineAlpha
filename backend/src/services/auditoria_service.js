const pool = require("../config/database");

/**
 * Registro centralizado de auditoria.
 * Tabela: auditoria_evento (append-only).
 * 
 * Nota: Se a tabela não tiver as colunas necessárias, o erro é ignorado
 * para não impactar o fluxo de negócio.
 */
async function registrarEventoAuditoria({
  acao,
  usuario = null,
  sessao = null,
  entidade = "auth",
  id_entidade = null,
  mensagem = null,
  contexto = null,
  req = null,
  tabela = null,
}) {
  const detalhePayload = {
    mensagem: mensagem || null,
    contexto: contexto || null,
  };

  if (req) {
    detalhePayload.ip =
      req.headers["x-forwarded-for"] || req.socket?.remoteAddress || null;
    detalhePayload.user_agent = req.headers["user-agent"] || null;
  }

  const detalheString = JSON.stringify(detalhePayload);

  try {
    // Tenta inserir com todas as colunas
    await pool.execute(
      `INSERT INTO auditoria_evento (id_sessao_usuario, acao, detalhe, id_usuario, tabela, id_usuario_espelho) VALUES (?, ?, ?, ?, ?, ?)`,
      [sessao, acao, detalheString, usuario, tabela, usuario]
    );
  } catch (err) {
    // Silencioso - não impactar fluxo de negócio
    console.warn("[auditoria] Ignorada:", err.message);
  }
}

module.exports = {
  registrarEventoAuditoria,
};
