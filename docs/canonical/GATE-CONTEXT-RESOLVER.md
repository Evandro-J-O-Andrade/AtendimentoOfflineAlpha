# GATE-CONTEXT-RESOLVER

```text
Tipo:           Auditoria de GATE
Status:         READ ONLY
Origem:         Banco Vivo (bancoMysql.md)
Classificação:  REUSE / ADAPT
Implementação:  NÃO
```

> Validação de engenharia do fluxo de resolução de contexto. Não é conhecimento novo; é
> confirmação de que o Kernel Runtime do Banco Vivo já cobre o Context Resolver. Vinculado a
> `MD-CANONICO-IA-007` (§17.2 Modo Audit-First) e a `GATE-PLATFORM-001`.

## Fluxo auditado

```text
sp_master_login
   ↓
sessao_usuario
   ↓
sp_auth_contexto_get
   ↓
sp_auth_contexto_set
   ↓
sp_sessao_contexto_get
   ↓
sp_sessao_contexto_set
   ↓
sp_sessao_assert
   ↓
sp_guardiao_runtime_assert
```

## Achados

```text
ACHADO
Objeto:   sp_master_login
Status:   DIVERGENTE
Motivo:   Não popula id_entidade e insere id_unidade = NULL; ambos NOT NULL em sessao_usuario.
          Lê usuario.senha (coluna senha_hash existe no Banco Vivo).
Classificação: ADAPT
Impacto:  CORE-001 · CORE-005 · Discovery

ACHADO
Objeto:   sessao_usuario
Status:   ENCONTRADO
Classificação: REUSE
Impacto:  Context Resolver

ACHADO
Objeto:   sp_auth_contexto_get / sp_auth_contexto_set
Status:   ENCONTRADO
Classificação: REUSE
Impacto:  Context Resolver

ACHADO
Objeto:   sp_sessao_contexto_get
Status:   DIVERGENTE
Motivo:   Lê su.id_local_operacional — coluna inexistente em sessao_usuario (usa id_local).
Classificação: ADAPT
Impacto:  Context Resolver

ACHADO
Objeto:   sp_sessao_contexto_set / sp_sessao_assert
Status:   ENCONTRADO
Classificação: REUSE
Impacto:  Context Resolver

ACHADO
Objeto:   sp_guardiao_runtime_assert
Status:   ENCONTRADO (fronteira)
Motivo:   Recebe (id_usuario, contexto, recurso) — não sessão. Backend mapeia sessão → usuário → contexto.
Classificação: REUSE
Impacto:  Infrastructure Runtime
```

## Divergências críticas (Backend × Banco Vivo)

1. **Tenant na criação da sessão** — `sp_master_login` omite `id_entidade` e seta `id_unidade = NULL`,
   mas a tabela exige ambos `NOT NULL` e **não há trigger** em `sessao_usuario`. SP dessincronizada
   ou dependente de pipeline externo. **Confirmar em ambiente vivo antes de ADAPT.**
2. **`sp_sessao_contexto_get` → `id_local_operacional`** — coluna inexistente; executaria com erro.
   **ADAPT obrigatório** (usar `id_local`).
3. **Guardian por usuário, não por sessão** — `sp_guardiao_runtime_assert(id_usuario, contexto,
   recurso)` não recebe a sessão. Este é o **bloqueio real** do Discovery Runtime.

## Plano de adaptação (sem novas SPs)

```text
1. ADAPT  sp_sessao_contexto_get   → id_local_operacional → id_local
2. ADAPT  sp_master_login          → popular id_entidade/id_unidade na criação (confirmar origem)
3. REUSE  sp_auth_contexto_* + sp_sessao_contexto_set + sp_sessao_assert
                                     → Backend ORQUESTRA: login → get → set → assert
4. REUSE  sp_guardiao_runtime_assert → Runtime consome contexto resolvido
```

## CONCLUSÃO

```text
REUSE    6
ADAPT    3
EXTEND   0
MERGE    0
PROPOSE  0

DECISÃO
Não criar novo componente.
Adaptar componentes existentes.
```

## QUADRO PADRÃO DE GATE

```text
OBJETO           Context Resolver (fluxo de contexto)

CONCEITO         ✅
MATERIALIZADO    ✅  (bancoMysql.md: sp_auth_contexto_*, sp_sessao_contexto_*, sp_sessao_assert)
CONSUMIDO        Backend ⚠ (PortalService zera tenant/contexto) · Frontend ✅ · Runtime ⚠
CONFORME         PARCIAL (sp_sessao_contexto_get id_local_operacional ; sp_master_login tenant)

CLASSIFICAÇÃO    REUSE · ADAPT

EVIDÊNCIA        bancoMysql.md (17380 / 17479 / 32241 / 32276 / 32115)
CONFIANÇA        ALTA

DECISÃO          GATE REJECTED (ADAPT pendente: tenant + id_local)
```
