# MAPA STORED PROCEDURES - FASE 5
Data: 2026-06-17
Fonte: backend/sql/Dump20260606.sql + backend/sql/STORED_PROCEDURES_MAP.md + backend/sql/MAPA_SP_CANÔNICO.md
Status: ANÁLISE DO DUMP REAL

---

## SPs MASTER (CORE DA ARQUITETURA)

| Procedure | Assinatura mínima conhecida | Status |
|-----------|------------------------------|--------|
| sp_master_dispatcher | (IN p_id_sessao, IN p_uuid_transacao, IN p_dominio, IN p_acao, IN p_id_referencia, IN p_payload) | CONFIRMADA |
| sp_master_query_dispatcher | (IN p_id_sessao, IN p_modulo, IN p_filtros) | CONFIRMADA |
| sp_master_login | (IN p_acao, IN p_payload) | CONFIRMADA |
| sp_master_orquestradora | (IN p_id_sessao, IN p_modulo, IN p_acao, IN p_payload) | CONFIRMADA |
| sp_master_registrar_evento | (IN p_uuid_transacao, IN p_dominio, IN p_acao, IN p_id_referencia) | CONFIRMADA |
| sp_auth_criar_sessao | Ref. em loginController.js | CONFIRMADA |
| sp_sessao_assert | Ref. em authMiddleware.js | CONFIRMADA |

Total estimado de sp_master_*: 68 (conforme varredura anterior)

---

## DOMÍNIOS MASTER ENCONTRADOS NO DUMP

### AUTH
Domínio: AUTH
Procedures:
- sp_auth_criar_sessao
- sp_auth_validar_token
- sp_auth_refresh
- sp_auth_logout

### OPERACIONAL (HIS)
Domínio: OPERACIONAL
Procedures principais encontradas:
- sp_fila_gerar_senha
- sp_fila_chamar
- sp_fila_cancelar
- sp_fila_finalizar_atendimento
- sp_fila_encaminhar
- sp_atendimento_*
- sp_triagem_*
- sp_medico_*
- sp_enfermagem_*
- sp_farmacia_dispensar
- sp_farmacia_estoque
- sp_estoque_*

### PAINEL
Domínio: PAINEL
Procedures:
- sp_painel_chamada
- sp_painel_fila
- sp_painel_status

### TOTEM
Domínio: TOTEM
Procedures:
- sp_totem_gerar_senha
- sp_totem_feedback
- sp_totem_opcoes

### PORTAL
Domínio: PORTAL
Procedures:
- sp_portal_noticia_*
- sp_portal_comunicado_*
- sp_portal_documento_*

### SOCIAL
Domínio: SOCIAL
Procedures encontradas no dump:
- sp_social_postagem_*
- sp_social_comentario_*
- sp_social_grupo_*
- sp_social_reacao_*

---

## DOMÍNIOS AUSENTES NO DUMP

| Domínio | Procedures esperadas | Status no dump | Status no backend |
|---------|----------------------|----------------|-------------------|
| CHAT | sp_chat_* | NÃO ENCONTRADO | NÃO ENCONTRADO |
| WIKI | sp_wiki_* | NÃO ENCONTRADO | NÃO ENCONTRADO |
| ANALYTICS | sp_analytics_* | NÃO ENCONTRADO | NÃO ENCONTRADO |
| AUTOMACAO | sp_automacao_* | NÃO ENCONTRADO | NÃO ENCONTRADO |

Observação: No banco existem tabelas e eventos genéricos, mas não foram encontradas procedures SP organizadas por esses domínios. Podem existir como procedures legadas ou ainda não mapeadas.

---

## TABELAS ONTOLÓGICAS CONFIRMADAS NO DUMP

| Tabela canônica | Presente no Dump20260606.sql |
|-----------------|------------------------------|
| saas_entidade | SIM |
| pessoa | SIM |
| pessoa_vinculo | SIM |
| usuario | SIM |
| sessao_usuario | SIM |
| sistema | SIM |
| unidade | SIM |
| local_operacional | SIM |
| workflow_ffa_evento | SIM |
| auditoria_evento | SIM |

---

## CONCLUSÃO FASE 5

- Domínios cobertos por procedures: AUTH, OPERACIONAL, PAINEL, TOTEM, PORTAL, SOCIAL.
- Domínios sem procedures organizadas: CHAT, WIKI, ANALYTICS, AUTOMACAO.
- O banco já possui pelo menos parte da ontologia canônica, mas ainda há risco de gaps nesses domínios ausentes.

FIM DO RELATÓRIO FASE 5
