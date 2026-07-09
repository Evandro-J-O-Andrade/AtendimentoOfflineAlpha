# FASE DUMP-001 — Auditoria Canônica de Objetos (SPs de Auth/Portal/Runtime)

## Status

**EM ANDAMENTO** — seed concluída (SPs de Auth/Portal/Runtime fornecidas). Auditório completo
do dump é contínuo. Tudo baseado em evidência: `database/dump/Dump20260618.sql` (canônico) e
`backend/src`.

## Princípio (Kilo — 100% evidência)

```text
DUMP → Inventário → Call Graph → Dependency Graph → REUSE → ADAPT → EXTEND → PROPOSE
```

Nunca propor criação antes da classificação em 5 camadas:

1. **Existe exatamente igual?** → REUSE
2. **Existe com outro nome?** → ADAPT
3. **Existe dividido (Master+Executores)?** → consolidar
4. **Existe parcialmente?** → EXTEND
5. **Não existe?** → PROPOSE

---

## 1. Object Inventory (seed)

| Objeto | No Dump20260618.sql | Chamado por (backend) | Classificação |
| :--- | :--- | :--- | :--- |
| `sp_auth_contexto_get` | ✅ (3) | `AuthService.context` (`AuthService.ts:85`) | REUSE (+ ADAPT/consolidar) |
| `sp_auth_contexto_set` | ✅ (3) | `AuthService.selectContext` (`AuthService.ts:105`) | REUSE (+ ADAPT/consolidar) |
| `sp_auth_menu_get` | ✅ (2) | `PortalService.navigation` (`PortalService.ts:18`) | REUSE |
| `sp_dispatcher_kernel` | ✅ (2) | (não chamado pelo backend atual) | REUSE |
| `sp_guardiao_absoluto` | ✅ (2) | (não chamado pelo backend atual) | REUSE |
| `sp_guardiao_runtime_assert` | ✅ (2) | (chamado por guardião runtime) | REUSE |
| `sp_master_login` | ✅ (5) | `AuthService.login` (`AuthService.ts:17`, ação `AUTH.LOGIN.REQUEST`) | REUSE |
| `sp_sessao_contexto_get` | ✅ (2) | `AuthService.session` (`AuthService.ts:64`) | REUSE |
| `sp_sessao_contexto_set` | ✅ (2) | (não chamado pelo backend atual) | REUSE |
| `sp_auth_permissions_evaluate` | ❌ **0** | `PermissionService.evaluate` (`PermissionService.ts:17`) | **PROPOSE/ADAPT (BLOQUEIO CORE-005)** |

> Conclusão da camada 1: das 7 SPs fornecidas, **6 existem iguais no dump** (REUSE). Apenas
> `sp_auth_permissions_evaluate` não existe (camada 5). O padrão **Master + Executors** que
> você propôs **já existe no dump** (`sp_master_login`, `sp_dispatcher_kernel`, `sp_guardiao_*`,
> `sp_executor_*`) — logo é REUSE, não PROPOSE.

---

## 2. Call Graph (real, ponta a ponta)

```text
LOGIN
  apps/portal/src/pages/Login/LoginPage.tsx:26  login(request)
        ▼
  packages/auth  AuthProvider.login  (AuthProvider.tsx:36)
        ▼
  backend  POST /auth/login  (routes/auth.ts:7)
        ▼
  AuthService.login  (AuthService.ts:17)
        ▼
  CALL sp_master_login(..., 'AUTH.LOGIN.REQUEST', ...)
        ▼
  sp_master_login  [DUMP ✅]

SESSION
  packages/auth  SessionResolver  (SessionResolver.ts:5)  GET /auth/session
        ▼
  backend  GET /auth/session  (routes/auth.ts:23)
        ▼
  AuthService.session  (AuthService.ts:64)
        ▼
  CALL sp_sessao_contexto_get(?)
        ▼
  sp_sessao_contexto_get  [DUMP ✅]

CONTEXT (get)
  apps/portal/src/pages/Context/ContextSelectionPage.tsx:18  fetch('/auth/context/...')  ⚠️ raw fetch
        ▼
  backend  GET /auth/context/:id  (routes/auth.ts:45)
        ▼
  AuthService.context  (AuthService.ts:85)
        ▼
  CALL sp_auth_contexto_get(?)
        ▼
  sp_auth_contexto_get  [DUMP ✅]

CONTEXT (set)
  ContextSelectionPage.tsx:45  selectContext(...)
        ▼
  packages/auth  AuthProvider.selectContext  (AuthProvider.tsx:60)
        ▼
  backend  POST /auth/context/select  (routes/auth.ts:56)
        ▼
  AuthService.selectContext  (AuthService.ts:105)
        ▼
  CALL sp_auth_contexto_set(?,?,?,?)
        ▼
  sp_auth_contexto_set  [DUMP ✅]

PORTAL / NAVEGATION
  PortalService.runtime  (PortalService.ts:89)
        ▼
  PortalService.navigation  (PortalService.ts:18)
        ▼
  CALL sp_auth_menu_get(?, @resultado, @sucesso, @mensagem)
        ▼
  sp_auth_menu_get  [DUMP ✅]

PERMISSIONS  ❌ BLOQUEIO
  PermissionService.evaluate  (PermissionService.ts:17)
        ▼
  CALL sp_auth_permissions_evaluate(?, @permissions)
        ▼
  sp_auth_permissions_evaluate  [DUMP ❌ AUSENTE]
```

---

## 3. Dependency Graph (tabelas consumidas por cada SP)

| SP | Tabelas envolvidas (evidência no corpo da SP) |
| :--- | :--- |
| `sp_master_login` | `usuario`, `login_tentativa`, `sessao_usuario` |
| `sp_sessao_contexto_get` | `sessao_usuario` |
| `sp_auth_contexto_get` | `sessao_usuario`, `usuario_unidade`+`unidade`, `usuario_perfil`+`perfil`, `usuario_local`+`local` |
| `sp_auth_contexto_set` | `sessao_usuario`, `usuario_unidade`, `usuario_perfil`, `usuario_local`, `usuario_contexto` (insert), `auditoria_evento` (insert) |
| `sp_auth_menu_get` | `sessao_usuario`, `permissao`, `perfil_permissao`, `permissao_local`, `menu_evento` |
| `sp_guardiao_runtime_assert` | `guardiao_acl_runtime` |
| `sp_dispatcher_kernel` | `fn_decision_fingerprint`, `sp_kernel_writer_lock/unlock`, `runtime_execution_queue` |

---

## 4. Domain Map

```text
AUTH (login/sessão/contexto)
  ├─ sp_master_login            (Master dispatcher por ação)
  ├─ sp_sessao_contexto_get      (contexto atual da sessão)
  ├─ sp_auth_contexto_get        (opções de contexto: unidades/perfis/locais)
  └─ sp_auth_contexto_set        (define contexto + snapshot + auditoria)

IAM (permissões/menu)
  ├─ sp_auth_menu_get            (menu dinâmico por perfil/local)
  └─ sp_auth_permissions_evaluate  (❌ AUSENTE — BLOQUEIO CORE-005)

RUNTIME (kernel/execução)
  ├─ sp_dispatcher_kernel        (enfileira em runtime_execution_queue)
  ├─ sp_executor_*               (assistencial/estoque/faturamento/fila/manchester/recepcao/cadastro)
  └─ sp_guardiao_*               (absoluto / runtime_assert / runtime_decidir / runtime_final)

PORTAL (experiência)
  └─ sp_auth_menu_get  → PortalService.navigation → PortalRuntimeContract.navigation
```

---

## 5. Runtime Map

```text
sp_dispatcher_kernel
  ├─ fn_decision_fingerprint (p_acao, p_id_tenant, p_id_usuario, p_payload)
  ├─ sp_kernel_writer_lock(v_uuid)  → runtime_execution_queue (PENDENTE)
  └─ sp_kernel_writer_unlock(v_lock)

Executores (domínio):
  sp_executor_assistencial_*  (anamnese/atendimento/evolucao/triagem)
  sp_executor_estoque_runtime
  sp_executor_faturamento_runtime
  sp_executor_fila_runtime
  sp_executor_manchester_runtime
  sp_executor_recepcao_abrir_atendimento
  sp_executor_cadastro_paciente_salvar

Guardião runtime:
  sp_guardiao_absoluto → valida sessão ativa
  sp_guardiao_runtime_assert → valida ACL (guardiao_acl_runtime)
  sp_guardiao_runtime_decidir / sp_guardiao_runtime_final
```

> **Nota:** o `PortalRuntimeContract` (frontend) NÃO consome `sp_dispatcher_kernel`/`sp_executor_*`
> hoje. O runtime de portal usa apenas `sp_auth_menu_get` + `sp_auth_permissions_evaluate`
> (esta ausente). Ou seja, há um Runtime de **domínio** (kernel) maduro no dump, mas o Runtime de
> **portal** ainda não o utiliza (ver `frontend-runtime-discovery.md`).

---

## 6. IAM Map

```text
Login        → sp_master_login (AUTH.LOGIN.REQUEST)
Session      → sp_sessao_contexto_get
Contexto     → sp_auth_contexto_get / sp_auth_contexto_set
Menu         → sp_auth_menu_get
Permissões   → sp_auth_permissions_evaluate  ❌ AUSENTE (fallback: deriva de sp_auth_menu_get)
Guardião     → sp_guardiao_absoluto / sp_guardiao_runtime_assert / sp_guardiao_runtime_decidir / sp_guardiao_runtime_final
```

---

## 7. Portal Map

```text
PortalService.runtime(idSessao)
  ├─ navigation  → sp_auth_menu_get
  ├─ applications (DERIVADO de navigation, sem SP própria)
  ├─ branding (hardcoded)
  ├─ dashboard (hardcoded, widgets:[])
  ├─ widgets  → []  (sem SP / sem fonte)
  ├─ notifications → []
  └─ permissions → sp_auth_permissions_evaluate  ❌ AUSENTE
```

> `applications` são derivados de `navigation` no backend — não há catálogo de aplicações
> próprio. `widgets` não tem fonte no dump nem no backend.

---

## 8. Duplicações Semânticas (Camada 2/3 — consolidação)

### DUP-1 — Contexto GET implementado em 3 superfícies

| Superfície | Onde | Retorna |
| :--- | :--- | :--- |
| `sp_auth_contexto_get` | standalone (dump) | result-sets: unidades, perfis, locais, contexto atual |
| `sp_sessao_contexto_get` | standalone (dump) | row: id_unidade/id_local/id_perfil da sessão |
| `sp_master_login` ramo `AUTH.CONTEXTO.GET` | dentro do Master | JSON: unidades/locais/perfis |

**Decisão:** existe dividido (Camada 3). O Master já orquestra contexto. Recomenda-se
consolidar: `sp_auth_contexto_get`/`sp_sessao_contexto_get` viram **executores** chamados pelo
Master `AUTH.CONTEXTO.GET`; o backend passa a rotear `context()`/`session()` pelo Master em vez
de SPs standalone. **Não criar nova SP.**

### DUP-2 — Contexto SET em 2 superfícies

`sp_auth_contexto_set` (standalone) e `sp_master_login` ramo `AUTH.CONTEXTO.SET`.
Mesma recomendação: consolidar no Master + executor.

### DUP-3 — backend `routes/auth.ts` define o router DUAS VEZES

`routes/auth.ts` contém a definição completa do router **duplicada** (linhas ~7-71 e ~73-120,
idênticas). Segundo registro é morto/confuso. **Risco de manutenção** — corrigir (remover duplicata).

---

## 9. Risk Report

| ID | Risco | Evidência | Severidade | Ação |
| :--- | :--- | :--- | :--- | :--- |
| R1 | `sp_auth_permissions_evaluate` ausente no dump, mas chamada por `PermissionService` | `PermissionService.ts:17`; dump 0 ocorrências | **ALTA (bloqueio)** | ADAPT a partir de `sp_auth_menu_get`; materializar SQL (já em `docs/database/procedures_raw_texts/sp_auth_permissions_evaluate.sql`) |
| R2 | Contexto GET/SET duplicado em 3/2 superfícies | `sp_auth_contexto_get`, `sp_sessao_contexto_get`, `sp_master_login` | MÉDIA | Consolidar em Master + Executors (DUP-1/DUP-2) |
| R3 | `routes/auth.ts` com router duplicado | `routes/auth.ts` (definição repetida) | MÉDIA | Remover duplicata |
| R4 | `ContextSelectionPage` usa `fetch()` direto | `ContextSelectionPage.tsx:18` | MÉDIA | Usar `packages/api` (FRONT-001 §7/§11) |
| R5 | Runtime de portal não usa Runtime de domínio (kernel) | `PortalService` vs `sp_dispatcher_kernel`/`sp_executor_*` | BAIXA | Futura FASE: portal consumir kernel runtime |

---

## 10. Conclusão (fatos)

- Das SPs fornecidas, **6/7 existem no dump** (REUSE); o padrão Master+Executors **já existe**.
- **`sp_auth_permissions_evaluate` é a única ausente** → PROPOSE/ADAPT (BLOQUEIO CORE-005).
- Há **duplicação semântica de contexto** (standalone vs Master) → candidata a consolidação,
  não a criação de novos objetos.
- O backend já está 100% conectado ao dump, exceto pela SP de permissões ausente.

**Próximo passo:** estender a auditoria para todas as SPs/tabelas/funções do `Dump20260618.sql`
(gerando Domain Map / Call Graph completos) e submeter R1–R5 ao ChatGPT (auditor técnico)
antes de qualquer materialização.

---

## 11. Portal Enterprise Domain Gap Analysis (CORE-003)

Análise de domínio orientada por **responsabilidade, não nome** (IA-007 §5.1).

### Banco atual

```text
Portal Enterprise: INEXISTENTE

Evidências:
- Tabelas `portal_*`:  apenas `portal_categoria` (ÓRFÃ, sem dados, só agrupamento/categoria).
- SPs `portal_*` / `sp_master_portal`: 0 ocorrências no dump.
- Runtime/contratos: existem (WidgetContract, PortalRuntimeEngine, WidgetRenderer registry),
  mas SEM persistência (PortalService.widgets/dashboard retornam [] mock).
- `painel_*` (10+ tabelas) NÃO é Portal: FKs → unidade/local/fila; sp_painel_* = operations;
  modules/painel = módulo clínico; nomes assistenciais (monitoramento_*, evento_stream, …).
```

### Conclusão

```text
portal_categoria  ≠  Portal Enterprise
(tabela isolada, sem cadeia de relacionamento, sem procedures, sem runtime fechado)
```

### Necessidade

```text
Novo bounded context: Portal Enterprise (metadado de composição de experiência)
  portal_widget, portal_dashboard, portal_dashboard_widget, portal_widget_config,
  portal_layout, portal_usuario_dashboard, portal_dashboard_permission, sp_master_portal
Classificação: PROPOSE (após prova de ausência — não é duplicação de painel_*)
Status:         PROPOSED / REQUIRE APPROVAL (aguarda ADR + MD Portal Enterprise + MAP Portal Domain)
```

> Decisão formal: `DECISION-LOG.md` **DEC-0005** (revoga/refina DEC-0001, que tratava
> `dashboard` como REUSE de `painel_*`).
