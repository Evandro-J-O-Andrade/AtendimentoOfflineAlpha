# MD 2 — CONTRATO DO FRONTEND (REACT)

React só chama sp_master_dispatcher.

## Request
{
  p_id_sessao_usuario,
  p_modulo,
  p_acao,
  p_payload
}

## Response
{
  sucesso,
  mensagem,
  dados,
  evento_uuid
}
