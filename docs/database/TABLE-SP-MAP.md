# TABLE-SP-MAP.md — Tabela → Procedures

> Seed 2026-07-09 (evidência). Inverso de `SP-TABLE-MAP.md`. Para cada tabela, veja ficha em
> `tables/<tabela>.md` e `tables_completas/<tabela>.md`.

## IAM (core)

### sessao_usuario
- **Lida por:** `sp_master_login`, `sp_sessao_contexto_get`, `sp_sessao_contexto_set`,
  `sp_auth_contexto_get`, `sp_auth_menu_get`, `sp_sessao_assert`, `sp_guardiao_absoluto`
- **Escrita por:** `sp_master_login`, `sp_sessao_contexto_set`, `sp_auth_contexto_set`
- **Audita:** `auditoria_evento`, `log_acesso_prontuario`
- **Frontend:** `LoginPage`, `ContextSelectionPage`, `EnterpriseShell` (via `PortalRuntimeContract`)

### usuario
- **Lida por:** `sp_master_login`, `sp_usuario_*`
- **Escrita por:** `sp_usuario_criar_contexto`, `sp_usuario_definir_senha`, `sp_usuario_trocar_senha`,
  `sp_usuario_vincular_unidade/local/sistema`
- **Status:** REUSE

### perfil / permissao / perfil_permissao
- **Lida por:** `sp_auth_menu_get`, `sp_auth_permissions_evaluate`, `sp_usuario_tem_permissao`,
  `sp_tem_permissao`
- **Escrita por:** `sp_master_*` (admin), `sp_patch_permissao`
- **Status:** REUSE

## Portal

### painel (+ painel_config, painel_lane, painel_local, painel_grupo, painel_mensagem)
- **Lida por:** `sp_painel_*`, `sp_auth_menu_get` (indiretamente via categoria)
- **Escrita por:** `sp_painel_config_set`, `sp_painel_inserir_senha`, `sp_painel_chamar_senha`
- **Runtime:** `fila_painel_runtime`, `assistencial_runtime_panel`, `painel_evento_stream`
- **Status:** REUSE — não criar `dashboard`/`dashboard_widget`; usar família `painel_*`

### portal_categoria
- **Lida por:** `sp_auth_menu_get` (monta navegação por módulo)
- **Status:** REUSE

## Runtime / Kernel

### runtime_execution_queue
- **Escrita por:** `sp_dispatcher_kernel`
- **Lida por:** workers (`sp_retry_semantico_worker`, `sp_runtime_*_exec`)
- **Status:** REUSE

### kernel_single_writer_lock / kernel_runtime_single_writer_lock
- **Escrita por:** `sp_kernel_writer_lock` / `sp_kernel_writer_unlock`
- **Status:** REUSE

### guardiao_acl_runtime
- **Lida por:** `sp_guardiao_runtime_assert`, `sp_guardiao_runtime_decidir`
- **Status:** REUSE

## Atendimento (exemplo de domínio)

### atendimento
- **Lida/Escrita por:** `sp_atendimento_*`, `sp_master_atendimento*`, `sp_executor_assistencial_*`,
  `sp_fila_*`, `sp_triagem_*`
- **Status:** REUSE

> ⚠️ Seed. Para todas as ~330 tabelas, ver `tables/*.md`. Ao criar tabela nova, registre aqui e
> em `TABLES` (índice) e em `DUPLICATION-MAP.md` (conferir se já existe equivalente).
