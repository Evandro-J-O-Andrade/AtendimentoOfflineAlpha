const pool = require("../config/database");

/**
 * Registro centralizado de auditoria.
 * Tabela: auditoria_evento (append-only).
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
    await pool.execute(
      `
        INSERT INTO auditoria_evento (
          id_sessao_usuario,
          entidade,
          id_entidade,
          acao,
          detalhe,
          id_usuario,
          tabela,
          id_usuario_espelho
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        sessao,
        entidade,
        id_entidade,
        acao,
        detalheString,
        usuario,
        tabela,
        usuario,
      ]
    );
  } catch (err) {
    // Não quebrar fluxo de negócio por falha de auditoria
    console.error("[auditoria_service] Falha ao registrar evento:", err.message);
  }
}

module.exports = {
  registrarEventoAuditoria,
};
