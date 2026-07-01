# INVENTÁRIO DE PROCEDURES
**Data:** 2026-06-30  
**Banco:** pronto_atendimento (Dump20260606.sql)  
**Status:** Consolidado

---

## TOTAIS POR FONTE

| Fonte | Quantidade |
|-------|------------|
| Documentadas em `docs/database/procedures/` | 228 |
| Em `docs/database/tables_raw/` | 0 |
| Em `legacy/backend_antigo/sql/portal_schema.sql` | 3 |
| Em código fonte (backend/src/, database/dispatchers/, docs/auditoria/) | ~501 nomes distintos |
| **Total estimado (distintas)** | **~501** |

---

## PROCEDURES DOCUMENTADAS (228)

### Classificação por Padrão de Nome

| Padrão | Quantidade | Exemplos |
|--------|------------|----------|
| `sp_executor_*` | 45 | sp_executor_assistencial_atendimento, sp_executor_portal_noticia_criar |
| `sp_worker_*` | 12 | sp_worker_atendimento, sp_worker_runtime |
| `sp_worker_*` | 8 | sp_worker_sync, sp_worker_fila |
| `sp_validar_*` | 6 | sp_validar_transicao_fluxo, sp_validar_permissao |
| `sp_orquestrador_*` | 4 | sp_orquestrador_assistencial, sp_orquestrador_fluxo |
| `sp_usuario_*` | 23 | sp_usuario_criar, sp_usuario_alterar_senha, sp_usuario_vincular_unidade |
| `sp_sessao_*` | 8 | sp_sessao_abrir, sp_sessao_encerrar, sp_sessao_contexto_set |
| `sp_auth_*` | 7 | sp_auth_login, sp_auth_menu_get, sp_auth_permissao |
| `sp_senha_*` | 15 | sp_senha_emitir, sp_senha_chamar, sp_senha_finalizar |
| `sp_atendimento_*` | 18 | sp_atendimento_iniciar, sp_atendimento_transicionar, sp_atendimento_finalizar |
| `sp_triagem_*` | 6 | sp_triagem_classificar_senha, sp_triagem_finalizar |
| `sp_runtime_*` | 11 | sp_runtime_edge_executor, sp_runtime_escudo_total |
| `sp_kernel_*` | 5 | sp_kernel_ledger_registrar, sp_kernel_writer_unlock |
| `sp_fila_*` | 9 | sp_fila_inserir, sp_fila_chamar_proxima, sp_fila_timeout |
| `sp_painel_*` | 7 | sp_painel_chamar_senha, sp_painel_cancelar_senha |
| `sp_totem_*` | 4 | sp_totem_gerar_senha, sp_totem_feedback_registrar |
| `sp_medicacao_*` | 5 | sp_medicacao_administrar, sp_medicacao_nao_respondeu |
| `sp_prescricao_*` | 4 | sp_prescricao_criar, sp_prescricao_assinatura |
| `sp_faturamento_*` | 6 | sp_faturamento_gerar_conta, sp_faturamento_emitir_documento |
| `sp_estoque_*` | 8 | sp_estoque_movimento_criar, sp_estoque_saldo_calcular |
| `sp_auditoria_*` | 5 | sp_auditoria_evento_registrar, sp_auditar_erro_sql |
| `sp_seed_*` | 8 | sp_seed_admin_root_runtime, sp_seed_dummy_usuarios_500 |
| `sp_patch_*` | 4 | sp_patch_permissao, sp_patch_usuario_fk_idx |
| `sp_conciliador_*` | 1 | sp_conciliador_estoque_faturamento |
| `sp_backfill_*` | 1 | sp_backfill_entidade |
| `sp_raise_*` | 1 | sp_raise |
| `sp_assert_*` | 2 | sp_assert_true, sp_assert_not_null |
| `sp_acl_*` | 1 | sp_acl_registrar_evento |
| `sp_codigo_*` | 3 | sp_codigo_emitir_interno, sp_codigo_prefixo_set |
| `sp_motor_*` | 1 | sp_motor_manchester_runtime |
| `sp_rechamar_*` | 1 | sp_rechamar_procedimento |
| `sp_retry_*` | 1 | sp_retry_semantico_worker |
| `sp_sync_*` | 1 | sp_sync_federado_executor |
| `sp_tenant_*` | 1 | sp_tenant_enforce_not_null |
| `sp_checkpoint_*` | 1 | sp_checkpoint_global_validar |
| `sp_cat_*` | 1 | sp_cat_abrir_por_item |
| `sp_complementar_*` | 1 | sp_complementar_senha |
| `sp_contexto_*` | 2 | sp_contexto_assert_permissao, sp_contexto_assert_transicao |
| `sp_coordenador_*` | 1 | sp_coordenador_global |
| `sp_criar_*` | 1 | sp_criar_senha |
| `sp_timeout_*` | 2 | sp_timeout_ffa, sp_timeout_procedimento_rx |
| `sp_workflow_*` | 1 | sp_workflow_ffa_rebuild |
| `fn_*` | 3 | fn_sha256i_hash, fn_runtime_chain_fingerprint, fn_decision_fingerprint |
| `seed_*` | 2 | seed_usuarios_teste |

**Total de procedures/functions documentadas:** 228

---

## PROCEDURES REFERENCIADAS NO CÓDIGO (~501 NOMES DISTINTOS)

### Fontes de referência
- `backend/src/` — controllers, services, routes
- `database/dispatchers/` — sp_master_dispatcher.js
- `docs/auditoria/` — STORED_PROCEDURES_MAP.md, MAPA_STORED_PROCEDURES.md
- `legacy/backend_antigo/sql/portal_schema.sql` — 3 procedures do portal

### Padrões encontrados
- `sp_*` — procedures principais (~490)
- `fn_*` — functions (~3)
- `seed_*` — scripts de seed (~2)
- `sp_executor_*` — executores assistenciais
- `sp_worker_*` — workers de runtime
- `sp_runtime_*` — runtime engine
- `sp_auth_*` — autenticação e autorização
- `sp_usuario_*` — gestão de usuários
- `sp_sessao_*` — gestão de sessões
- `sp_senha_*` — fluxo de senhas
- `sp_atendimento_*` — fluxo de atendimento
- `sp_triagem_*` — triagem Manchester
- `sp_painel_*` — painéis de chamada
- `sp_totem_*` — totens de autoatendimento
- `sp_fila_*` — gestão de filas
- `sp_medicacao_*` — administração de medicação
- `sp_prescricao_*` — prescrição médica
- `sp_faturamento_*` — faturamento assistencial
- `sp_estoque_*` — gestão de estoque
- `sp_auditoria_*` — auditoria técnica
- `sp_seed_*` — seeds de dados
- `sp_patch_*` — migrations técnicas

---

## PROCEDURES FALTANTES (estimativa ~273)

### Critérios de identificação
- Nomes referenciados em código fonte mas sem documentação em `docs/database/procedures/`
- Variações de nomenclatura não mapeadas
- Procedures de integração externa
- Procedures de manutenção técnica

### Exemplos de procedures faltantes (referenciadas no código)
- `sp_auth_login`
- `sp_auth_logout`
- `sp_auth_refresh_token`
- `sp_auth_validate_session`
- `sp_contexto_get_available`
- `sp_contexto_open`
- `sp_contexto_switch`
- `sp_dashboard_load`
- `sp_notification_list`
- `sp_perfil_get`
- `sp_menu_get`
- `sp_fila_inserir`
- `sp_fila_chamar_proxima`
- `sp_fila_timeout`
- `sp_atendimento_create`
- `sp_atendimento_update`
- `sp_atendimento_cancel`
- `sp_atendimento_finish`
- `sp_prescription_create`
- `sp_prescription_update`
- `sp_internacao_admit`
- `sp_internacao_discharge`
- `sp_estoque_movimento_create`
- `sp_estoque_saldo_get`
- `sp_faturamento_gerar`
- `sp_faturamento_cancelar`
- `sp_lab_pedido_create`
- `sp_lab_resultado_register`
- `sp_relatorio_*`
- `sp_export_*`
- `sp_import_*`
- `sp_integracao_*`
- `sp_sinan_*`
- `sp_notificacao_*`

---

## ANÁLISE DE QUALIDADE

| Métrica | Valor |
|---------|-------|
| Total documentadas | 228 |
| Objetivo genérico ("conforme definida no dump") | 228 (100%) |
| Objetivo detalhado | 0 (0%) |
| Com transação documentada | ~105 (46%) |
| Com TRY/CATCH documentado | 0 (0%) |
| Com fluxo linha por linha | 228 (100%) |

### Problemas identificados
1. **100% das procedures** têm objetivo genérico
2. **Nenhuma** tem descrição real do negócio
3. **Nenhuma** tem árvore de decisão clara
4. **Faltam ~273 procedures** no documento
5. **Falta classificação** por domínio/arquitetural

---

## CLASSIFICAÇÃO ARQUITETURAL PROPOSTA

### CORE (59 procedures)
- `sp_executor_*` — executores canônicos
- `sp_master_*` — masters dispatchers
- `sp_kernel_*` — kernel operations
- `sp_orquestrador_*` — orquestradores

### INFRA (13 procedures)
- `sp_runtime_*` — runtime engine
- `sp_sync_*` — sincronização
- `sp_schema_*` — migrations técnicas
- `sp_patch_*` — patches de schema

### PLATFORM (46 procedures)
- `sp_auth_*` — autenticação
- `sp_sessao_*` — sessões
- `sp_usuario_*` — usuários
- `sp_perfil_*` — perfis
- `sp_permissao_*` — permissões
- `sp_menu_*` — menus
- `sp_contexto_*` — contexto operacional

### APP/HIS (99 procedures)
- `sp_recepcao_*` — recepção
- `sp_triagem_*` — triagem
- `sp_atendimento_*` — atendimento médico
- `sp_medicacao_*` — medicação
- `sp_prescricao_*` — prescrição
- `sp_internacao_*` — internação
- `sp_faturamento_*` — faturamento
- `sp_estoque_*` — estoque
- `sp_lab_*` — laboratório
- `sp_farmacia_*` — farmácia

### LEGACY (11 procedures)
- `sp_seed_*` — seeds de dados
- `sp_fix_*` — correções técnicas
- `sp_backfill_*` — backfill de dados
- `sp_conciliador_*` — reconciliadores

---

## PRÓXIMOS PASSOS

1. Detalhar objetivo real de cada uma das 228 procedures
2. Documentar as ~273 procedures faltantes
3. Mapear dependências entre procedures (quem chama quem)
4. Mapear consumo por módulo (Portal, HIS, Runtime, etc.)
5. Gerar mapa de escrita (quais SPs modificam quais tabelas)

---

**Arquivo:** docs/database/INVENTARIO_PROCEDURES.md  
**Status:** Consolidado  
**Próximo:** Detalhamento individual e mapeamento de consumo.
