# GATE-AUTHSERVICE-ADAPT

```text
Status:  READ ONLY
Tipo:    GATE de aceitação do ADAPT-AUTHSERVICE
Origem:  Banco Vivo (bancoMysql.md) · Canon · Backend · ADAPT-AUTHSERVICE
```

> Último GATE antes da implementação do ADAPT do `AuthService`. Pergunta única: o plano de adaptação
> elimina todos os bypasses **sem alterar a responsabilidade do Kernel**? Vinculado a
> `GATE-BACKEND-RUNTIME`, `BACKEND-RUNTIME-AUDIT` e `ADAPT-AUTHSERVICE`.

## Pergunta do GATE

> **O plano de adaptação elimina todos os bypasses sem alterar a responsabilidade do Kernel?**

Se **não** → `REJECTED`.
Se **sim** → `ACCEPTED` (inicia implementação).

## Critérios derivados (checklist de aceite)

```text
□ AuthService NÃO faz SQL direto em usuario (router por sp_master_login)
□ Validação de senha permanece no Backend (REUSE) — não movida para SP sem GATE
□ JWT tratado conforme papel no Kernel (sp_master_login espera token_jwt)
□ sp_master_login passa a popular id_entidade / id_unidade / id_perfil na sessão
□ AuthService.session mapeia id_entidade (não id_sistema)
□ AuthService.session lê id_local (não id_local_operacional)
□ Consome sp_sessao_assert + sp_auth_contexto_* (REUSE)
□ Nenhum componente novo criado
□ Nenhuma responsabilidade do Kernel assumida pelo Backend
```

## Mapa de aceite (do ADAPT-AUTHSERVICE)

| Gap | Eliminado pelo ADAPT? | Altera responsabilidade do Kernel? |
| --- | --- | --- |
| SQL direto em `usuario` | ✅ (router sp_master_login) | ❌ (Kernel já cria sessão) |
| `id_entidade ← id_sistema` | ✅ (corrigir mapeamento) | ❌ |
| `id_local_operacional` | ✅ (id_local) | ❌ |
| tenant/contexto nulo | ✅ (consumir sp_auth_contexto_*) | ❌ |
| validação de senha no Backend | ⚠️ mantida (REUSE) | ❌ (Kernel não valida senha) |

## Status

```text
STATUS:  PENDENTE (REJECTED até o ADAPT ser aplicado e validado contra este GATE)

ACCEPTED  quando todos os critérios acima forem verdadeiros.
REJECTED  se qualquer bypass permanecer ou se o Backend assumir responsabilidade do Kernel.
```

## Consequência

```text
ACCEPTED → inicia implementação do ADAPT-AUTHSERVICE
         → GATE-BACKEND-RUNTIME (reavaliar Kernel Compliance)
         → ADAPT PortalService → GATE → ADAPT PermissionService → GATE → Runtime Adapter → GATE → Discovery Runtime
```

## QUADRO PADRÃO DE GATE

```text
OBJETO           ADAPT do AuthService (porta de entrada do Kernel)

CONCEITO         ✅
MATERIALIZADO    ✅  (sp_master_login etc. no Banco Vivo)
CONSUMIDO        Backend ✅ (AuthService) · mas com bypass (SQL direto)
CONFORME         NÃO (id_entidade←id_sistema ; id_local_operacional ; SQL direto)

CLASSIFICAÇÃO    ADAPT (6) · REUSE (validação de senha no Backend) · PROPOSE 0

EVIDÊNCIA        AuthService.ts:59/71/97/99 + bancoMysql.md:25668
CONFIANÇA        ALTA (Banco Vivo) · MÉDIA (Backend)

DECISÃO          GATE PENDENTE (ACCEPTED após ADAPT eliminar bypasses sem mexer no Kernel)
```
