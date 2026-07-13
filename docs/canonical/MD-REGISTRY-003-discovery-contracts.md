# MD-REGISTRY-003 — Discovery Contracts

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Etapa 2 — fase CONTRATOS (pré-SQL)
Fundação travada: MD-REGISTRY-000 / MAP-REGISTRY-002 (não reabertos)
Origem: validação conceitual do usuário — classificação PROPOSE
```

---

## Princípio

O Contrato de Discovery descreve **DESCOBERTA**, não **EXECUÇÃO**.

```text
Registry
   ↓
Resolver
   ↓
Discovery Capability
   ↓
Runtime
   ↓
Master
   ↓
Executor
   ↓
SP
```

Discovery NUNCA é Dispatcher disfarçado (MD-REGISTRY-000).

---

## 1. DiscoveryQueryContract — a pergunta

```text
DiscoveryQuery
 ── identidade      : pessoa / usuario
 ── sessao          : id_sessao
 ── contexto        : tenant, unidade/local, contexto_operacional
 ── consumidor      : WEB | MOBILE | KIOSK | TV | AI | MCP
 ── consulta
      tipo_entidade
      filtro
      capability
      dominio
 ── restricoes
      permissao
      consumidor
      runtime_type
```

Responsabilidade: **informar o que o consumidor deseja descobrir.**

Contexto é OBRIGATÓRIO e segue a separação canônica
Pessoa ≠ Usuário ≠ Sessão ≠ Contexto. A mesma Capability pode
ter respostas distintas por consumidor (Constituição Art. 12).

---

## 2. DiscoveryResultContract — a resposta

```text
DiscoveryResult
 ── itens[]
      codigo, tipo, descricao, status, versao
      origem_materializacao   (REUSE | ADAPT | EXTEND | MERGE | PROPOSE)
 ── relacoes[]
      origem, destino, tipo_relacao
 ── capabilities[]
 ── runtimes[]
 ── tools[]
 ── apis[]
 ── events[]
```

Responsabilidade: **entregar conhecimento navegável. Não executa nada.**

---

## 3. RuntimeResolutionContract — separa Discovery de Runtime

```text
Discovery encontra : "Existe essa Capability"
Resolver decide   : "Qual Runtime atende neste contexto"

Capability
   ↓
Runtime candidates
   ↓
PRIMARY selecionado
```

Responsabilidade: mapear descoberta → execução sem acoplar as duas.

---

## API de Discovery

Principal (contrato único e escalável):

```http
POST /discovery/query
```

Entrada:
```json
{ "type": "CAPABILITY", "filter": { "domain": "pharmacy" } }
```

Saída:
```json
{ "items": [], "relations": [], "available_runtime": [] }
```

Atalhos (conveniência, **NÃO** arquitetura principal):
```text
GET /discovery/capabilities
GET /discovery/runtimes
GET /discovery/tools
GET /discovery/events
```

### Discovery NÃO é catálogo manual
A API consulta o metamodelo; NUNCA mantém segunda fonte.
```text
Consumidor → Discovery API → Discovery Resolver
   → Registry + Arestas → Knowledge Graph → Resposta
```
Evitar:
```text
Discovery API → tabela discovery_capability isolada   (❌ 2ª fonte da verdade)
```
Auditoria confirma: não existe tabela `discovery`/`discovery_capability`
no Banco Vivo. Ela NÃO deve ser criada.

### API Discovery nasce como Runtime
Discovery é Capability ⇒ entra no pipeline da plataforma:
```text
Capability DISCOVERY
   ↓
Discovery Runtime
   ↓
sp_master_discovery
   ↓
sp_discovery_query (Executor)
   ↓
Registry / Knowledge Graph
```
A API NÃO acessa Registry diretamente; passa pelo Runtime.

---

## GATE Intermediário de Discovery (pré-SQL)

Antes de gerar qualquer SQL, validar (ver GATE-PLATFORM-001):

```text
CONTRATO       : definição de entrada e saída existe?
RASTREABILIDADE: a resposta navega
                 Capability → Runtime → Master → Executor → SP?
SEGURANÇA      : respeita tenant / contexto / permissão / consumidor?
                 (IA, Mobile e Portal NÃO enxergam o mesmo grafo)
```

Falha em qualquer um → domínio retorna a ADR + Arquiteto Chefe.

---

## Auditoria Banco Vivo (transição para API Discovery)

Classificação REUSE/ADAPT/EXTEND/MERGE/PROPOSE (dump Dump20260618.sql):

| Elemento Discovery                | No dump? | Classificação | Evidência |
|-----------------------------------|----------|---------------|-----------|
| Contexto (Identidade/Sessão/Contexto) | SIM | REUSE | `usuario_contexto`, `sessao_contexto_historico`, `contexto_atendimento`, `runtime_contexto`; SPs `sp_auth_contexto_get/set`, `sp_sessao_contexto_get/set`, `sp_contexto_assert_permissao`, `sp_usuario_criar_contexto` |
| Capability / Permissão           | SIM      | REUSE + ADAPT | `permissao` (nome_procedure/acao_frontend/metadata) é origem canônica embrionária; SPs `sp_auth_permissions_evaluate`, `sp_permissao_assert/validar`, `sp_sessao_tem_permissao`, `sp_usuario_tem_permissao`. ADAPT: Capability Registry (Etapa 1) estende `permissao`. NÃO criar `discovery_capability` |
| Catálogo de menu/UI              | SIM      | ADAPT | `sp_auth_menu_get` (serve menu por SP, sem tabela menu), `portal_categoria`, `erro_catalogo`, `configuracao` |
| Tenant / Domínio                 | SIM      | REUSE | `tenant_registry` |
| Runtime (infra)                  | SIM      | REUSE + EXTEND | tabelas `runtime_*`; SPs `sp_*_runtime` (REUSE). EXTEND: `runtime_registry` cataloga a descoberta dos runtimes |
| `runtime_registry`               | NÃO      | PROPOSE | catálogo de descoberta dos runtimes; NÃO substitui runtime existente |
| Discovery (Query/Result/Resolver) | NÃO    | PROPOSE | nenhum `sp_discovery_*` ou tabela `discovery` |
| `discovery_capability` isolada   | NÃO      | PROPOSE (NÃO CRIAR) | seria 2ª fonte da verdade |

Decisão: Discovery **REUSE/ADAPT** contexto, permissão e catálogos
existentes; **PROPOSE** apenas os artefatos de Discovery
(`sp_discovery_query`, Discovery Runtime, arestas de descoberta).
Nunca criar tabela `discovery_capability` isolada.

---

## Auditoria do Endpoint (backend canônico)

Antes de materializar, auditou-se o backend real (`backend/src`) — não o dump.

| Pergunta                                  | Resposta | Classificação |
|-------------------------------------------|----------|---------------|
| 1. API já existe parcialmente?            | SIM      | ADAPT |
| 2. Controller/service semelhante?         | SIM (`PortalService`, `PermissionService`) | ADAPT |
| 3. Padrão de resposta no backend?         | SIM (Express `res.json` + `500 ERRO_INTERNO`) | REUSE |
| 4. Middleware de sessão/contexto?         | PARCIAL (`idSessao` via param; SPs `sp_sessao_contexto_*` / `sp_auth_contexto_*` existem no dump, mas não são chamados no service) | EXTEND |
| 5. Padrão de erro/auditoria?              | PARCIAL (500 genérico; auditoria em SP/`kernel_ledger`) | EXTEND |

Evidências:
- `routes/portal.ts`: `GET /portal/runtime|navigation|permissions|widgets|applications|dashboard|notifications|branding`.
- `core/portal/PortalService.ts`: `runtime()` compõe `navigation` (→ `sp_auth_menu_get`) + `permissions` (→ `sp_auth_permissions_evaluate`) + `widgets[]` + ….
- `core/permissions/PermissionService.ts`: `evaluate()` → `sp_auth_permissions_evaluate`.
- Frontend (`packages/runtime`, `packages/api`, `apps/portal`): `PortalRuntimeEngine`, `PortalApi`, `WidgetResolver`, `ContextResolver`, `PermissionResolver` — pipeline já conectado (ver `frontend-runtime-discovery.md`, `GATE-FRONT-001-discovery.md`).

Decisão:
**Discovery API = ADAPT** dos endpoints/services existentes.
`POST /discovery/query` é **PROPOSE** como camada de consolidação do
contrato único, **REUTILIZANDO** `PortalService` / `PermissionService` /
`sp_auth_menu_get` / `sp_auth_permissions_evaluate`. Nunca duplicar fonte.

Bloqueios identificados (não impedem o contrato, mas impactam materialização):
- **CORE-005**: `sp_auth_permissions_evaluate` está PROPOSTO e **ainda não aplicado ao banco** (DT-001). Discovery depende dele para segurança (permissão/consumidor).
- `PortalService.runtime` entrega `user/tenant/context = null`: contexto de sessão ainda não está amarrado aos SPs `sp_sessao_contexto_*` / `sp_auth_contexto_*`.
- `widgets[]` vazio: fonte de dados de widget pendente (domínio Widget, à parte).

---

## Decisões pré-SQL e Sequência de Materialização

Discovery é **evolução arquitetural** de capacidades existentes, não
feature isolada. Classificação global:

```text
Banco Vivo          → REUSE / ADAPT / PROPOSE
Backend existente   → ADAPT
Novos elementos     → PROPOSE
```

### Decisão 1 — Resolver CORE-005 antes de materializar
`sp_auth_permissions_evaluate` está PROPOSTO e **não aplicado** (DT-001).
Discovery depende de autorização; sem ela, descobre o que o
consumidor não deveria enxergar. Fluxo correto:

```text
Discovery Query → Context Resolver → Permission Resolver
   → Capability Resolver → Runtime Resolver
```

**Discovery não materializa antes de CORE-005 estar resolvido/adaptado.**

### Decisão 2 — Amarrar sessão → tenant → contexto (ADAPT)
`PortalService.runtime` entrega `user/tenant/context = null`.
Auditar (sem criar tabela nova):
`sessao_usuario`, `usuario_contexto`, `sessao_contexto_historico`,
`saas_entidade`, `tenant_registry` + SPs de contexto.
Correção deve ser **ADAPT** da fonte oficial de sessão→contexto.

### Decisão 3 — Mínimo do SQL PROPOSE
```text
runtime_registry        → identidade do Runtime (NÃO guarda capabilities)
capability_runtime      → aresta (com role/PRIMARY)
runtime_master          → aresta
runtime_dependencia     → aresta (FUNCIONAL/OPERACIONAL)
runtime_evento          → aresta
runtime_contrato        → aresta
```
**NÃO criar** `discovery_result` / `discovery_cache` / `discovery_capability`
(seria estado paralelo). O executor consulta o grafo e devolve a resposta.

### GATE Discovery SQL (pré-condição)
```text
CONTRATO  : ✅ DiscoveryQueryContract / DiscoveryResultContract fechados
BANCO VIVO: ✅ nenhuma tabela equivalente; fontes REUSE identificadas
SEGURANÇA : ⚠️ CORE-005 resolvido/adaptado
CONTEXTO  : ⚠️ sessão → tenant → contexto resolvido
GRAFO     : ✅ relações definidas
```

### Sequência recomendada
```text
1. Resolver CORE-005
2. Amarrar sessão/contexto real
3. Aprovar SQL PROPOSE
4. Materializar runtime_registry + arestas
5. Criar sp_master_discovery
6. Criar executor discovery (sp_discovery_query)
7. Expor POST /discovery/query (ADAPT de PortalService/PermissionService)
8. Rodar GATE final (CONSISTÊNCIA / NAVEGAÇÃO / INTEGRIDADE)
```
