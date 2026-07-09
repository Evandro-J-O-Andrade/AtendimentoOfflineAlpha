# CALL-GRAPH.md — Quem chama quem (real)

> Seed 2026-07-09. Fonte: `DUMP-001-audit.md` (backend→SP) + `runtime-map.md` (frontend→backend).
> Não criar SP/tsx fora destas cadeias sem classificar em `INVENTORY.md`.

## Login
```text
LoginPage.tsx:26
  → AuthProvider.login (packages/auth)
    → POST /auth/login (routes/auth.ts:7)
      → AuthService.login (AuthService.ts:17)
        → sp_master_login (AUTH.LOGIN.REQUEST)   [DUMP ✅]
          → sessao_usuario
```

## Sessão
```text
SessionResolver.ts:5 (GET /auth/session)
  → AuthService.session (AuthService.ts:64)
    → sp_sessao_contexto_get   [DUMP ✅]
      → sessao_usuario
```

## Contexto (get)
```text
ContextSelectionPage.tsx:18 (fetch /auth/context/:id)  ⚠️ raw fetch (R4)
  → GET /auth/context/:id (routes/auth.ts:45)
    → AuthService.context (AuthService.ts:85)
      → sp_auth_contexto_get   [DUMP ✅]
        → usuario_unidade · usuario_perfil · usuario_local · sessao_usuario
```

## Contexto (set)
```text
ContextSelectionPage.tsx:45 → AuthProvider.selectContext (AuthProvider.tsx:60)
  → POST /auth/context/select (routes/auth.ts:56)
    → AuthService.selectContext (AuthService.ts:105)
      → sp_auth_contexto_set   [DUMP ✅]
        → sessao_usuario · usuario_contexto · auditoria_evento
```

## Portal / Navegação
```text
PortalRuntimeComposer (providers.tsx:109)
  → PortalApi.runtime → GET /portal/runtime/:id (routes/portal.ts:6)
    → PortalService.runtime (PortalService.ts:89)
      → PortalService.navigation (PortalService.ts:18)
        → sp_auth_menu_get   [DUMP ✅]
          → sessao_usuario · permissao · perfil_permissao · permissao_local · menu_evento
```

## Permissões ❌ BLOQUEIO
```text
PortalRuntimeComposer → PortalApi.permissions
  → GET /portal/permissions/:id (routes/portal.ts:17)
    → PermissionService.evaluate (PermissionService.ts:17)
      → sp_auth_permissions_evaluate   [DUMP ❌ AUSENTE]
```

## Runtime de Domínio (Kernel)
```text
sp_dispatcher_kernel
  → fn_decision_fingerprint
  → sp_kernel_writer_lock / sp_kernel_writer_unlock
  → runtime_execution_queue (PENDENTE)
        ↓
  sp_executor_assistencial_* / sp_executor_estoque_runtime /
  sp_executor_faturamento_runtime / sp_executor_fila_runtime /
  sp_executor_manchester_runtime / sp_executor_recepcao_abrir_atendimento /
  sp_executor_cadastro_paciente_salvar
        ↓
  sp_guardiao_absoluto / sp_guardiao_runtime_assert / sp_guardiao_runtime_decidir / sp_guardiao_runtime_final
```

> ⚠️ O `PortalRuntimeContract` (frontend) **ainda não consome** `sp_dispatcher_kernel` /
> `sp_executor_*` (R5 em `DUMP-001-audit.md`).
