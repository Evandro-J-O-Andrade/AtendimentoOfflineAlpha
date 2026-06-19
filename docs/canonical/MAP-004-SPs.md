# MAP-004 — Stored Procedures

## Status

Documento Canônico De Mapeamento.
Fonte: Dump20260606.sql.
SPs confirmadas: 225.

---

## Agrupamento Por Domínio

| Domínio | Prefixo / Padrão | Status |
|---------|------------------|--------|
| AUTH | sp_auth_*, sp_acl_*, sp_admin_sessao_* | CANONICO |
| AUDITORIA | sp_auditar_*, sp_auditoria_evento_* | CANONICO |
| DISPATCHER | sp_checkpoint_*, sp_codigo_* | CANONICO |
| OPERACIONAL / HIS | sp_atendimento_*, sp_chamar_senha, sp_complementar_senha | CANONICO |
| FARMACIA | sp_farmacia_* | CANONICO |
| ESTOQUE / FATURAMENTO | sp_conciliador_* | CANONICO |
| CAT | sp_cat_* | CANONICO |
| ADMIN | sp_admin_*, seed_* | LEGADO / ADMIN |

## SPs Canônicas De Segurança

- sp_assert_not_null
- sp_assert_true
- sp_guardiao_runtime_final
- sp_sessao_assert (inferida por docs canônicos, nome exato ainda por conferir)
- sp_permissao_assert (inferida por docs canônicos, nome exato ainda por conferir)

## SPs De Integração / IA

- sp_master_dispatcher (referenciado no README)
- sp_master_orquestradora (referenciado no README)
- sp_executor_* (referenciado no README)

## Observações

- Nenhuma regra de negócio no backend além do roteamento para SPs.
- Controller/service do legado atuam como camada de transporte HTTP; execução real está no banco.
