# CONTEXT-RESOLUTION-FLOW

```text
Tipo:           Documento de trabalho de GATE (grafo auditável)
Status:         READ ONLY
Origem:         Banco Vivo (bancoMysql.md) + GATE-CONTEXT-RESOLVER + GATE-RUNTIME-CHAIN
Classificação:  REUSE / ADAPT / PROPOSE
Implementação:  NÃO (sem SQL; backend adapta o Kernel existente)
```

> Detalha a resolução `sessão → usuário → tenant → contexto → guardião → capability → dispatcher →
> executor` como um grafo auditável. Cada transição traz Origem / SP / Tabela / Objeto / Contrato /
> Status. Não é MD, ADR nem BR — é artefato de engenharia do GATE. Vinculado a
> `GATE-CONTEXT-RESOLVER.md` e `GATE-RUNTIME-CHAIN.md`.

## Grafo

```text
sessão
   ↓ (1) sp_sessao_assert
id_usuario
   ↓ (2) sp_auth_contexto_get
tenant
   ↓ (3) sp_auth_contexto_set / sp_sessao_contexto_set
contexto
   ↓ (4) sp_guardiao_runtime_assert
Capability
   ↓ (5) runtime_registry / capability_registry
Dispatcher
   ↓ (6) sp_dispatcher_kernel
Executor
   ↓ (7) sp_executor_*
Banco / Evento / Ledger / Auditoria
```

## Transições auditadas

### (1) sessão → usuário

```text
Origem:   sessao_usuario
SP:       sp_sessao_assert (32115)
Tabela:   sessao_usuario
Objeto:   id_usuario, id_unidade, id_local, id_perfil
Contrato: JSON { id_usuario, id_unidade, id_local, id_perfil, ... }
Status:   REUSE
Nota:    Valida sessão ativa/expirada e contexto (id_unidade NOT NULL); permissão opcional.
```

### (2) usuário → tenant

```text
Origem:   sessao_usuario.id_entidade
SP:       sp_auth_contexto_get (17380)
Tabela:   sessao_usuario (id_entidade)
Objeto:   id_entidade (tenant)
Contrato: SESSAO_INVALIDA_OU_SEM_TENANT se id_entidade IS NULL
Status:   REUSE (⚠️ ADAPT em sp_master_login — v. GATE-CONTEXT-RESOLVER)
Nota:    sp_auth_contexto_get exige id_entidade NOT NULL; sp_master_login não o popula na criação.
```

### (3) tenant → contexto

```text
Origem:   sessao_usuario (id_unidade, id_local, id_perfil) + usuario_contexto
SP:       sp_auth_contexto_get (leitura) · sp_auth_contexto_set / sp_sessao_contexto_set (escrita)
Tabela:   sessao_usuario, usuario_contexto, usuario_unidade, usuario_perfil, usuario_local
Objeto:   id_unidade, id_local, id_perfil
Contrato: valida vínculos (USUARIO_NAO_VINCULADO_UNIDADE / PERFIL_INVALIDO_PARA_UNIDADE / LOCAL_INVALIDO_PARA_UNIDADE)
Status:   REUSE / ADAPT
Nota:    sp_auth_contexto_set grava snapshot em usuario_contexto + audita CONTEXT_SET.
         sp_sessao_contexto_get contém bug (id_local_operacional inexistente) → ADAPT.
```

### (4) contexto → guardião

```text
Origem:   sessão resolvida (id_usuario + contexto operacional)
SP:       sp_guardiao_runtime_assert (22696)
Tabela:   guardiao_acl_runtime
Objeto:   permissionamento de runtime (contexto, recurso)
Contrato: SEM_PERMISSAO_RUNTIME se (id_usuario, contexto, recurso, permitido=1) ausente
Status:   REUSE (fronteira)
Nota:    Guardian recebe (id_usuario, contexto, recurso) — NÃO a sessão.
         O Backend DEVE mapear sessão → id_usuario → contexto antes de chamá-lo. Este é o bloqueio real.
```

### (5) guardião → Capability

```text
Origem:   conceito canônico (MAP-REGISTRY-001 / BR-REGISTRY-001)
Banco:    ❌ (sem tabela capability / capability_registry)
Implementação: PROPOSE (runtime_registry / capability_registry)
Status:   PROPOSE
Nota:    Capability existe no Canon; não está materializada no Banco Vivo. Ver GATE-RUNTIME-CHAIN.
```

### (6) Capability → Dispatcher

```text
Origem:   sp_dispatcher_kernel
SP:       sp_dispatcher_kernel (18834)
Tabela:   runtime_execution_queue, runtime_contexto
Objeto:   orquestração/roteamento
Contrato: dispatch por contexto/recurso
Status:   REUSE
Nota:    Kernel já orquestra; Backend coordena, não reimplementa.
```

### (7) Dispatcher → Executor

```text
Origem:   sp_executor_*
SP:       sp_executor_* (19732)
Tabela:   tabelas de domínio (atendimento, fila, farmácia, ...)
Objeto:   execução de dados
Contrato: executa após guardião/dispatcher
Status:   REUSE
Nota:    Executores já existem no Banco Vivo; ADAPT ao contexto resolvido.
```

## CONCLUSÃO

```text
REUSE    5   (1,2,3,6,7)
ADAPT    2   (2: tenant em sp_master_login · 3: sp_sessao_contexto_get)
PROPOSE  1   (5: runtime_registry / capability_registry)
MERGE    0
EXTEND   0

DECISÃO
Não escrever SQL. O fluxo já é coberto pelo Kernel existente, salvo:
  - ADAPT do backend para popular tenant na sessão (sp_master_login) e corrigir sp_sessao_contexto_get;
  - mapear sessão → id_usuario → contexto antes de sp_guardiao_runtime_assert;
  - PROPOSE de runtime_registry/capability_registry (metamodelo) via GATE, antes do Discovery Runtime.
```
