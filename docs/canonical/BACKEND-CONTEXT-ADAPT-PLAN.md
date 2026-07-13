# BACKEND-CONTEXT-ADAPT-PLAN

```text
Tipo:           Plano de adaptação (GATE)
Status:         READ ONLY
Classificação:  REUSE / ADAPT
Implementação:  NÃO (sem SQL, sem alterar SPs, sem backend ainda)
```

> Responde a uma única pergunta: **como o Backend deve consumir o Kernel Runtime já existente?**
> Não define funcionamento interno. Vinculado a `BACKEND-RUNTIME-AUDIT`, `CONTEXT-RESOLUTION-FLOW`,
> `GATE-CONTEXT-RESOLVER` e `GATE-RUNTIME-CHAIN`.

## 1. Estado atual (fatos encontrados)

```text
AuthService
   → sp_master_login (login)
   → SQL DIRETO em authenticate()  (SELECT usuario.senha — bypass do Kernel)
   → sp_sessao_contexto_get (session)  [lê id_local_operacional inexistente]
   → sp_auth_contexto_get / sp_auth_contexto_set (contexto)
        ↓
PortalService
   → sp_auth_menu_get (navigation)
   → runtime() retorna tenant: null, context: null   ← AQUI O BACKEND PERDE TENANT/CONTEXTO
        ↓
PermissionService
   → sp_auth_permissions_evaluate (AUSENTE no banco — CORE-005)
        ↓
Banco
```

- Onde nasce a sessão: `sp_master_login` (via `AuthService.login`).
- Onde o backend perde o tenant: `PortalService.runtime()` zera `tenant/context` (92–95); `AuthService.session()` mapeia `id_entidade ← id_sistema` (97).
- Onde perde o contexto: mesmo ponto acima + `sp_sessao_contexto_get` com coluna inexistente.
- Onde chama Permission: `PermissionService.evaluate` → `sp_auth_permissions_evaluate` (ausente).
- Onde chama Runtime: **nunca** — não há `RuntimeService`.
- Onde chama Dispatcher/Guardian: **nunca** — `sp_dispatcher_kernel` / `sp_guardiao_runtime_assert` não são invocados.

## 2. Fluxo desejado (só Kernel existente)

```text
Login
   ↓ sp_master_login
sessao_usuario
   ↓ sp_auth_contexto_get
Frontend escolhe contexto
   ↓ sp_auth_contexto_set
sp_sessao_assert
   ↓ (Backend Runtime orquestra)
sp_guardiao_runtime_assert
   ↓
sp_dispatcher_kernel
   ↓ sp_executor_*
Banco
```

Nenhuma peça nova. O Backend **coordena**; o Kernel **executa**.

## 3. Pontos de adaptação

| Camada | Situação atual | Banco Vivo | Classificação |
| --- | --- | --- | --- |
| AuthService.login | cria sessão via Kernel | REUSE | ✅ |
| AuthService.authenticate | SQL direto + JWT próprio | ADAPT (consolidar em sp_master_login) | ⚠️ |
| AuthService.session | id_entidade←id_sistema; id_local_operacional | ADAPT | ⚠️ |
| PortalService.runtime | tenant/context = null | ADAPT (consumir sp_sessao_assert + sp_auth_contexto_get) | ⚠️ |
| PermissionService | chama sp_auth_permissions_evaluate (ausente) | EXTEND/PROPOSE (CORE-005) | ⚠️ |
| ContextResolver (novo serviço) | inexistente | ADAPT (reutilizar SPs do Kernel) | ⚠️ |
| RuntimeService | inexistente | ADAPT (não criar; orquestrar via Kernel) | ⚠️ |
| Dispatcher/Guardian | não consumidos | REUSE (conectar) | ✅ |

## 4. Contratos necessários (sem código)

```text
RuntimeContext
  id_sessao
    ↓ id_usuario        (sp_sessao_assert)
    ↓ id_entidade       (tenant — sp_auth_contexto_get)
    ↓ id_unidade        (contexto — sp_auth_contexto_get/set)
    ↓ id_local
    ↓ id_perfil

RuntimeAuthorization
  RuntimeContext
    ↓ Capability        (runtime_registry/capability_registry — PROPOSE metamodelo)
    ↓ Guardian          (sp_guardiao_runtime_assert)
    ↓ Resultado         (permitido / SEM_PERMISSAO_RUNTIME)
```

## 5. Checklist do ADAPT

```text
Portal Runtime
  □ Recebe id_sessao
  □ Resolve id_usuario        (sp_sessao_assert)
  □ Resolve id_entidade       (tenant — sp_auth_contexto_get)
  □ Resolve id_unidade/local  (contexto — sp_auth_contexto_get/set)
  □ Executa assert            (sp_sessao_assert)
  □ Chama Guardian            (sp_guardiao_runtime_assert)
  □ Encaminha Dispatcher      (sp_dispatcher_kernel)
  □ Nunca consulta permissões diretamente (sem SQL em usuario)
```

## 6. O que NÃO pode fazer (PROIBIDO)

```text
PROIBIDO
  Criar Runtime paralelo
  Criar tabela de contexto
  Criar cache de permissões
  Duplicar sessão
  Resolver ACL no frontend
  Ignorar sp_sessao_assert
  Ignorar sp_guardiao_runtime_assert
  Consultar Registry diretamente antes de materializado
  Fazer SQL direto em usuario (manter sp_master_login como única entrada)
```

## CONCLUSÃO

```text
REUSE    2   (AuthService.login · Dispatcher/Guardian já existem)
ADAPT    5   (authenticate SQL direto · session id_entidade/id_local · PortalService null · ContextResolver · RuntimeService)
EXTEND   1   (sp_auth_permissions_evaluate — CORE-005)
PROPOSE  0   (sem novo componente; metamodelo entra via GATE)

DECISÃO
Backend vira consumidor disciplinado do Kernel:消除 SQL direto, parar de zerar tenant/contexto,
conectar Guardian/Dispatcher e materializar sp_auth_permissions_evaluate (CORE-005). Sem SQL novo.
```
