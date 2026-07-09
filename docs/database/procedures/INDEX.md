# PROCEDURES.md — Inventário Vivo de Stored Procedures

> Seed 2026-07-09. Fonte: `database/dump/Dump20260618.sql` (CREATE PROCEDURE) + `DUMP-001-audit.md`.
> Padrão presente no dump: **Master (dispatcher por ação) + Executor + Guardião**.
> Status padrão: **REUSE** (já existe no dump).

## Padrão Arquitetural (evidência no dump)

```text
Master (orquestra por ação/domínio)
  ├─ Executor (executa uma responsabilidade)
  └─ Guardião (valida antes de executar)
```

---

## Master / Dispatcher

### sp_master_login
- **Tipo:** Master (dispatcher por ação: AUTH.LOGIN.REQUEST, AUTH.CONTEXTO.GET/SET, AUTH.SESSAO.ASSERT, AUTH.LOGOUT.REQUEST)
- **Responsabilidade:** Orquestrar o fluxo de autenticação/contexto
- **Chamado por:** `AuthService.login` (`AuthService.ts:17`)
- **Status:** REUSE
- ⚠️ Contém ramos `AUTH.CONTEXTO.GET/SET` que **duplicam** `sp_auth_contexto_get/set` (ver DUP-1/DUP-2 em `DUMP-001-audit.md`)

### sp_dispatcher_kernel
- **Tipo:** Master (kernel runtime)
- **Responsabilidade:** Enfileirar ação em `runtime_execution_queue` (com `fn_decision_fingerprint`, `sp_kernel_writer_lock/unlock`)
- **Chamado por:** (não usado pelo backend atual; disponível para domínio)
- **Status:** REUSE

---

## Auth / Contexto

### sp_auth_menu_get
- **Tipo:** Executor
- **Responsabilidade:** Montar navegação dinâmica por perfil/local
- **Lê:** `sessao_usuario`, `permissao`, `perfil_permissao`, `permissao_local`
- **Escreve:** `menu_evento`
- **Chamado por:** `PortalService.navigation` (`PortalService.ts:18`)
- **Status:** REUSE

### sp_auth_contexto_get
- **Tipo:** Executor
- **Responsabilidade:** Retornar opções de contexto (unidades/perfis/locais) + contexto atual
- **Lê:** `sessao_usuario`, `usuario_unidade`+`unidade`, `usuario_perfil`+`perfil`, `usuario_local`+`local`
- **Chamado por:** `AuthService.context` (`AuthService.ts:85`)
- **Status:** REUSE (⚠️ sobreposto por `sp_master_login` AUTH.CONTEXTO.GET)

### sp_auth_contexto_set
- **Tipo:** Executor
- **Responsabilidade:** Definir contexto da sessão + snapshot + auditoria
- **Lê:** `sessao_usuario`, `usuario_unidade`, `usuario_perfil`, `usuario_local`
- **Escreve:** `sessao_usuario`, `usuario_contexto`, `auditoria_evento`
- **Chamado por:** `AuthService.selectContext` (`AuthService.ts:105`)
- **Status:** REUSE (⚠️ sobreposto por `sp_master_login` AUTH.CONTEXTO.SET)

### sp_sessao_contexto_get
- **Tipo:** Executor
- **Responsabilidade:** Contexto atual da sessão (row)
- **Lê:** `sessao_usuario`
- **Chamado por:** `AuthService.session` (`AuthService.ts:64`)
- **Status:** REUSE

### sp_sessao_contexto_set
- **Tipo:** Executor
- **Status:** REUSE

---

## Guardião (runtime / acesso)

### sp_guardiao_absoluto
- **Responsabilidade:** Validar sessão ativa
- **Lê:** `sessao_usuario`
- **Status:** REUSE

### sp_guardiao_runtime_assert
- **Responsabilidade:** Validar ACL (`guardiao_acl_runtime`)
- **Lê:** `guardiao_acl_runtime`
- **Status:** REUSE

### sp_guardiao_runtime_decidir / sp_guardiao_runtime_final
- **Status:** REUSE (família guardião runtime)

---

## Executores de Domínio (famílias no dump)

- **Assistencial:** `sp_executor_assistencial_anamnese_salvar`, `sp_executor_assistencial_atendimento_iniciar`,
  `sp_executor_assistencial_atendimento_finalizar`, `sp_executor_assistencial_evolucao_salvar`,
  `sp_executor_assistencial_triagem_iniciar`, `sp_executor_assistencial_triagem_finalizar`,
  `sp_executor_assistencial_triagem_salvar`, `sp_executor_assistencial_runtime`
- **Estoque:** `sp_executor_estoque_runtime`, `sp_estoque_movimentar`, `sp_estoque_movimento_criar`,
  `sp_estoque_movimento_item_add`, `sp_estoque_produto_criar_com_codigo`, `sp_estoque_produto_set_codigo`,
  `sp_conciliador_estoque_faturamento`
- **Faturamento:** `sp_executor_faturamento_runtime`
- **Fila:** `sp_executor_fila_runtime`, `sp_fila_chamar_proxima`, `sp_fila_finalizar`, `sp_fila_tipo_por_local`,
  `sp_chamar_senha`, `sp_criar_senha`, `sp_complementar_senha`, `sp_finalizar_senha`
- **Manchester:** `sp_executor_manchester_runtime`, `sp_emitir_evento_manchester`
- **Recepcao:** `sp_executor_recepcao_abrir_atendimento`
- **Cadastro:** `sp_executor_cadastro_paciente_salvar`
- **Atendimento:** `sp_atendimento_transicionar`, `sp_atendimento_finalizar_evasao`, `sp_atendimento_senha_nao_compareceu`
- **Farmácia:** `sp_farmacia_dispensar_registrar`, `sp_farm_dispensacao_criar`, `sp_farm_dispensacao_registrar`,
  `sp_farm_reserva_confirmar`, `sp_farm_*` (várias)
- **FFA:** `sp_ffa_orquestrador_transicao`, `sp_ffa_gpat_gerar`, `sp_ffa_gpat_garantir`, `sp_ffa_adicionar_item`
- **Fluxo:** `sp_fluxo_estoque`, `sp_fluxo_executor_matriz`, `sp_fluxo_guardiao_transicao`, `sp_fluxo_verificar_autorizacao`
- **Util/Auditoria:** `sp_assert_not_null`, `sp_assert_true`, `sp_auditoria_evento_registrar`, `sp_auditar_erro_sql`,
  `sp_acl_registrar_evento`, `sp_seed_usuarios_teste`, `sp_backfill_entidade`, `sp_fix_columns_entidade`,
  `sp_fix_fk_unidade`, `sp_gera_protocolo_lab`, `sp_codigo_emitir_interno`, `sp_codigo_mapear_externo`,
  `sp_codigo_prefixo_resolver`, `sp_codigo_prefixo_set`, `sp_coordenador_global`, `sp_checkpoint_global_validar`,
  `sp_admin_painel_filtros_seed_all`, `sp_admin_sessao_revogar`, `sp_iniciar_execucao_procedimento_rx`, `sp_gatekeeper_assistencial`

---

## ❌ Ausente (BLOQUEIO)

### sp_auth_permissions_evaluate
- **Status:** **PROPOSE / ADAPT** (0 ocorrências no dump)
- **Chamado por:** `PermissionService.evaluate` (`PermissionService.ts:17`)
- **Ação:** ADAPT a partir de `sp_auth_menu_get`; SQL já em
  `docs/database/procedures_raw_texts/sp_auth_permissions_evaluate.sql` (CORE-005)
