# MD-CANONICO-IA-007 — Lei do Banco como Fonte da Verdade e do Knowledge Graph Vivo

## Status

```text
CANÔNICO
OBRIGATÓRIO
VINCULANTE PARA TODAS AS IAs (Kilo / Gemini / ChatGPT / Claude / Copilot)
FROZEN v1.0  (DEC-0004 — Kernel de Governança congelado; não criar novos artefatos)
```

> **FREEZE v1.0:** Nenhum novo documento de governança será criado, salvo se um problema real
> demonstrar lacuna não resolvível pelos artefatos existentes. Próximo ganho = automatizar os
> gates (ver `DECISION-ENGINE.json` + `ARCHITECTURE-TESTS.md`), não expandir a documentação.

---

## 0. Objetivo

Transformar o dump SQL de "inventário de banco" em **base de conhecimento operacional** da
plataforma — um **Knowledge Graph do Sistema** navegável por qualquer IA antes de qualquer
implementação, e parte do **processo de engenharia** (não apenas documentação).

Esta lei eleva `docs/database/` a um componente ativo de governança. Complementa:
- `MD-CANONICO-IA-005` (Lei de Engenharia e Materialização)
- `MD-CANONICO-IA-002` (Lei de Governança Arquitetural — Regra do Knowledge Graph)

---

## 1. Princípio da Fonte da Verdade × Fonte de Navegação

A distinção é obrigatória e deliberada:

```text
FONTES DA VERDADE (autoridade física — co-iguais)
  • Dump SQL     (realidade do banco: o que existe)
  • Código       (realidade da implementação: quem realmente USA o que existe)
        ↓ deriva
KNOWLEDGE GRAPH (docs/database/)  ← índice INTELIGENTE DERIVADO do Dump + Código
        ↓
DECISION ENGINE (governança da evolução: gates + classificação)
        ↓
IMPLEMENTAÇÃO
```

> Documentação Canônica (MD / MAP / BR / ADR / FRONT) é **arquitetura desejada**, não fonte
> física de verdade — alinhado a `PROCESSO_MIGRATIONS.md` (Dump = LEGADO, MD/MAP = DESEJADO,
> SQL = EVOLUÇÃO).

- **O Knowledge Graph NUNCA é a verdade.** Ele é um índice derivado do Dump **e** do Código.
- O dump sozinho não mostra tudo (ex.: `sp_auth_menu_get` existe, mas `PortalService` →
  `PortalApi` → `PortalRuntimeProvider` → `EnterpriseShell` só aparece lendo o código). Por isso
  Dump **e** Código são as duas verdades; o KG apenas reflete e cruza ambas.
- **Consequência:** editar o MAP sem alterar o Dump/Código é anti-padrão. A mudança real começa e
  termina no Dump (e no código). O KG apenas reflete.
- **Artefatos derivados:** tudo em `docs/database/` (MAPs, CALLGRAPH, fichas, DECISION-*) é
  regenerável/auditável a partir do **Dump + Código**. Se o Dump muda, os índices são
  recalculados (ver `checklist_integridade.ps1`, `generate_tables_docs.ps1`) — nunca editados à mão
  como fonte. Assim a documentação não "envelhece" em relação ao sistema real.

---

## 2. Lei do Knowledge Graph Vivo

Toda evolução do banco deve atualizar o Knowledge Graph. Nenhuma implementação começa sem
consultá-lo. O KG é a camada que cruza as fontes de verdade para impedir duplicação semântica.

### 2.1 Estrutura obrigatória

```text
docs/database/
├── DATABASE-MAP.md        ← porta de entrada obrigatória (lei + índice)
├── INVENTORY.md           ← algoritmo obrigatório pré-implementação
├── SP-TABLE-MAP.md        ← SP → tabelas (lê / escreve / audita)
├── TABLE-SP-MAP.md        ← tabela → SPs que a consomem (grafo de impacto)
├── FRONT-SP-MAP.md        ← frontend (tsx) → SP
├── BACKEND-SP-MAP.md      ← backend service → SP
├── DUPLICATION-MAP.md     ← regra de não-duplicação por responsabilidade
├── CHANGELOG.md           ← registro de toda mudança (REUSE/ADAPT/EXTEND/MERGE/PROPOSE)
├── tables/                ← ficha por tabela (com ID canônico + nível de confiança)
├── procedures/            ← ficha por SP   (com ID canônico + nível de confiança)
├── functions/             ← índice de funções
├── runtime/               ← índices runtime_* / kernel_*
├── modules/               ← DOMAINS.md (decomposição de domínios)
├── callgraph/             ← CALLGRAPH.md (cadeias reais)
└── views/                 ← kilo-views.json
```

### 2.2 Aresta do grafo (exemplo canônico)

```text
sessao_usuario (DB-TB-0257)
    ├── sp_master_login (DB-SP-0001)
    │        ├── LoginController (BACK-0007)
    │        ├── AuthService (BACK-0011)
    │        └── LoginPage.tsx (FRONT-0003)
    ├── sp_auth_contexto_get (DB-SP-0002)
    │        └── ContextSelectionPage.tsx (FRONT-0004)
    └── sp_auth_menu_get (DB-SP-0003)
             └── EnterpriseShell (FRONT-0009)
```

A IA deve saber **quem usa quem** e **em qual camada**, não apenas que o objeto existe.

---

## 3. Níveis de Confiança (Confidence Levels)

Cada objeto do banco possui um status de confiabilidade, derivado da cobertura de fontes.

```text
sp_master_login (DB-SP-0001)
  STATUS:  ★★★★★
  Fonte:
    ✓ Dump
    ✓ Backend
    ✓ Frontend
    ✓ Runtime
    ✓ Documentação
  Decisão: REUSE
```

```text
sp_auth_permissions_evaluate (DB-SP-0042)
  STATUS:  ★
  Fonte:
    ✗ Dump
    ✓ Backend
    ✓ Documentação
  Decisão: PROPOSE (ausente no Dump → materializar)
```

Escala (★ = 1..5): número de fontes de verdade que confirmam o objeto. Um objeto ausente no
Dump tem, no máximo, ★★ — e exige PROPOSE com SQL. Nenhuma IA trata um objeto ★/★★ como
canônico sem materialização no Dump.

### Maturidade + Status (além da Confiança)

A confiança diz "existe/está confirmado"; a **maturidade** diz "está pronto para produção".

```text
DB-SP-0007  sp_auth_menu_get
  Confiança: ★★★★★
  Maturidade: Enterprise
  Status: Produção

DB-SP-0042  sp_auth_permissions_evaluate
  Confiança: ★
  Maturidade: Planned
  Status: CORE-005 (proposto)
```

Escala de Maturidade: `PLANNED → PROTOTYPE → BETA → PRODUCTION → ENTERPRISE`.
Status: `PRODUÇÃO | CORE-XXX | PROPOSTO | BLOQUEADO | MERGE-PENDENTE`.

---

## 4. ID Canônico (independente de nome)

Todo objeto recebe um ID canônico estável. O nome pode mudar; o ID não.

```text
DB-SP-0001   sp_master_login
DB-SP-0002   sp_auth_contexto_get
DB-TB-0257   sessao_usuario
DB-TB-0101   painel
FRONT-0003   PortalRuntime (PortalRuntime.tsx)
BACK-0011    PermissionService
RT-0009      assistencial_runtime_panel
```

Esquema:
- `DB-SP-####` Stored Procedure
- `DB-TB-####` Tabela
- `DB-FN-####` Function
- `DB-VW-####` View
- `BACK-####` Backend service/controller
- `FRONT-####` Frontend page/component/provider
- `RT-####` Runtime/kernel

Os IDs são registrados nas fichas (`tables/`, `procedures/`) e referenciados nos `*MAP.md`,
garantindo rastreabilidade mesmo após renomeação.

---

## 5. Algoritmo Obrigatório (executar ANTES de qualquer implementação)

Nenhuma linha de SQL ou TypeScript é escrita sem concluir esta sequência:

```text
1.  Ler /dump/Dump20260618.sql
        ↓
2.  Ler DATABASE-MAP.md
        ↓
3.  Procurar TABELA existente            → SIM → REUSE
        ↓
4.  Procurar TABELA EQUIVALENTE          → SIM → ADAPT
        ↓
5.  Procurar SP existente                → SIM → REUSE
        ↓
6.  Procurar SP SEMELHANTE               → SIM → ADAPT
        ↓
7.  Procurar DISPATCHER existente        → SIM → ligar nele
        ↓
8.  Procurar EXECUTOR / AUDITORIA / RUNTIME existente → SIM → usar
        ↓
9.  Consultar GRAFO DE IMPACTO (TABLE-SP-MAP / CALLGRAPH)
        ↓
10. Classificar e — só se necessário — PROPOSE + implementar
```

Regra de ouro: **nunca criar um objeto só porque não achou o nome esperado.**

Busca por responsabilidade, nesta ordem:
1. Mesmo nome · 2. Mesmo domínio · 3. Mesma responsabilidade · 4. Mesmo fluxo ·
5. Mesmo call graph · 6. Mesmo contrato · 7. Mesma tabela.
Somente se **todas** falharem → PROPOSE.

**Busca por FAMÍLIA (antes do nome exato):** a busca expande para o prefixo de família do
domínio, não apenas um identificador. Exemplos obrigatórios:
- "dashboard" **(Painel Clínico / TV Display — monitoramento, chamadas, eventos, displays)** →
  `painel`, `painel_config`, `painel_lane`, `painel_local`, `painel_grupo`,
  `painel_evento_stream`, `painel_alertas_tempo` (REUSE, não PROPOSE).
  ⚠️ **Não confundir com Portal Enterprise.** Portal (home do usuário, widgets, dashboards
  administrativos, preferências) é um bounded context **distinto** e **não existe** no dump
  (só `portal_categoria`, órfã). Portal Enterprise → PROPOSE (`portal_*`); ver §5.1.
- "runtime" → `runtime_*`, `kernel_*`.
- "auth" → `auth_*`, `sessao_*`, `usuario_*`.
- "fila" → `fila_*`, `fila_painel_runtime`.
O nome pode ser diferente; a **responsabilidade** é igual → REUSE/ADAPT, nunca PROPOSE.

### 5.1 Princípio: Responsabilidade, não Nome — `painel_*` ≠ Portal Enterprise

A família `painel_*` **não** é o Portal Enterprise. Mesmo que ambas evoquem "painel/dashboard",
suas **responsabilidades** são diferentes. A regra de ouro (linha 212) exige decidir por
**responsabilidade**, não por similaridade de nome — foi exatamente o reuse-by-name de `painel_*`
para Portal que gerou a incorreção corrigida em CORE-003 / DEC-0005.

| Domínio | Responsabilidade | Evidência (Dump + Código) |
| --- | --- | --- |
| `painel_*` (Painel Clínico / TV Display) | telas assistenciais, monitores, displays, TVs, painéis de chamada, ambientes físicos | FKs → `unidade`/`local`/`fila`; `sp_painel_*` classificadas como `operations` em `tools/sp-analyzer`;`modules/painel` é módulo clínico; nomes `painel_monitoramento_especialidade`, `painel_evento_stream`, `painel_consumo_evento` |
| Portal Enterprise (`portal_*`) | entrada da plataforma, home do usuário, navegação, módulos, dashboards administrativos, widgets, atalhos, preferências | **inexistente**: única tabela `portal_*` é `portal_categoria` (órfã, sem dados); nenhuma `sp_portal_*` / `sp_master_portal`; só contratos + runtime em código (`WidgetContract`, `PortalRuntimeEngine`) |

**Decisão (CORE-003 / DEC-0005):**
- `painel_*` → **REUSE / EVOLVE** dentro do próprio domínio clínico. **Não** alimenta Portal.
- Portal Enterprise → **PROPOSE** novo bounded context
  (`portal_widget`, `portal_dashboard`, `portal_dashboard_widget`, `portal_widget_config`,
  `portal_layout`, `portal_usuario_dashboard`, `portal_dashboard_permission`, `sp_master_portal`).
  Materializar SQL **após** ADR — não antes (ver `DECISION-LOG.md`).

---

## 6. Decisão Canônica: REUSE → ADAPT → EXTEND → MERGE → PROPOSE

```text
REUSE    → já existe igual                 → usar
ADAPT    → existe sob outro nome/camada    → adaptar
EXTEND   → existe parcialmente             → estender
MERGE    → existem pedaços espalhados       → consolidar num só (eliminar duplicação)
PROPOSE  → não existe (após prova)         → criar + SQL + CHANGELOG
```

### MERGE (etapa entre EXTEND e PROPOSE)

Quando comportamentos relacionados já existem em objetos distintos, **consolidar** em vez de
criar outro.

```text
Existe:
  sp_master_login
  sp_auth_contexto_get
  sp_auth_contexto_set

Ao invés de criar outra SP de contexto:
  → MERGE
  → mover comportamento para o Master + Executor canônico
  → eliminar duplicação
  → atualizar Call Graph e níveis de confiança
```

MERGE reduz a superfície de manutenção e evita a fragmentação que o projeto já identificou
(`DUMP-001-audit.md` DUP-1 / DUP-2).

---

## 7. Grafo de Impacto (Dependências)

O KG deve representar **dependências**, não apenas consumo. Alterar uma tabela revela o impacto
imediato nas SPs que a usam.

```text
sp_master_login (DB-SP-0001)
  ↓ Depende de
  usuario (DB-TB-xxxx)
  login_tentativa (DB-TB-xxxx)
  sessao_usuario (DB-TB-0257)
  usuario_contexto (DB-TB-xxxx)
  auditoria_evento (DB-TB-xxxx)
```

Se alguém alterar `usuario_contexto`, a IA sabe imediatamente que o impacto alcança:

```text
usuario_contexto
  → sp_master_login
  → sp_auth_contexto_get
  → sp_auth_contexto_set
```

Isso é o **grafo de impacto** — a base do Impact Analyzer.

---

## 8. Impact Analyzer (obrigatório antes de alterar)

Toda alteração começa por uma medição de impacto, nunca por código.

```text
Quero alterar: painel (DB-TB-0101)
  ↓
Consultar TABLE-SP-MAP
  ↓
Consultar CALLGRAPH
  ↓
Consultar BACKEND-SP-MAP
  ↓
Consultar FRONT-SP-MAP
  ↓
Consultar runtime/
  ↓
Resultado:
  Impacto = 7 procedures · 3 services · 2 páginas · 1 runtime · 2 contratos
```

Só após conhecer o impacto a IA escreve código. O resultado do analyzer é registrado em
`CHANGELOG.md` e na ficha do objeto alterado.

---

## 9. Pipeline Canônico de Execução

Toda escrita de negócio segue responsabilidades únicas, com EntryPoint e Domain Rules explícitos:

```text
Entry Point          (fronteira de entrada)
  ↓
Master Procedure     (valida a AÇÃO / recebe a requisição)
  ↓
Guardião             (valida sessão, tenant, contexto, invariantes básicas)
  ↓
Policy Engine        (políticas globais: feature flags, licenciamento, plano SaaS,
                      horário de operação, modo manutenção, regras institucionais)
  ↓
Permission Evaluate  (decide se AQUELE usuário pode executar AQUELA ação)
  ↓
Business Orchestrator (coordena o fluxo; decide quais executores acionar)
  ↓
Dispatcher           (distribui para o executor apropriado; inclusive async)
  ↓
Executor             (realiza a alteração de dados)
  ↓
Domain Rules         (regras de negócio do domínio — fora do Executor)
  ↓
Auditoria            (registra o que ocorreu)
  ↓
Evento               (emite evento de domínio)
  ↓
Ledger               (registro imutável / sincronização)
  ↓
Snapshot Runtime     (estado de runtime para offline-first)
  ↓
Runtime              (consome o snapshot; sincronização offline)
```

- `Guardião` valida **integridade**; `Policy` aplica **políticas globais**; `Permission` decide
  **autorização específica**. A separação escala para múltiplos produtos/tenants.
- `Domain Rules` deixa explícito onde ficam as regras de negócio; o Executor não as carrega.
- **Master orquestra apenas**: não acumula regra de negócio. Contexto pertence a
  `sp_master_contexto` → `sp_auth_contexto_get/set`; menu a `sp_master_menu` → `sp_auth_menu_get`
  (ver MERGE em `DUPLICATION-MAP.md` / `DUMP-001` DUP-1/DUP-2). `sp_master_login` concentra só
  autenticação.
- Nenhuma SP concentra auth + policy + authz + regra + persistência + auditoria.
- Dispatcher existente (`sp_dispatcher_kernel`, `sp_master_*`, `sp_executor_*`) é **REUSE**.
- Auditoria/Evento/Ledger/Runtime existentes são **REUSE**.

---

## 10. Regra de Não-Duplicação Semântica

Antes de criar qualquer objeto, consultar `DUPLICATION-MAP.md`. Casos canônicos já decididos:

| Queria criar | Decisão | Existente |
|---|---|---|
| `dashboard` / `dashboard_widget` (Painel **Clínico/TV Display**) | REUSE/ADAPT | família `painel_*` |
| `portal_*` (Portal Enterprise: widgets/dashboards administrativos) | PROPOSE | **inexistente** no dump (só `portal_categoria` órfã) — novo bounded context |
| nova SP de contexto | MERGE/ADAPT | `sp_auth_contexto_get/set`, `sp_sessao_contexto_get`, `sp_master_login` |
| novo dispatcher | REUSE | `sp_dispatcher_kernel`, `sp_master_*` |
| tabela de permissões do portal | REUSE | `permissao`/`perfil`/`perfil_permissao`/`guardiao_acl_runtime` |
| runtime de fila | REUSE | `fila_painel_runtime`/`runtime_*`/`kernel_*` |

---

## 11. Decision Engine (o cérebro da engenharia)

O algoritmo deixa de ser implícito e vira artefato explícito: `docs/database/DECISION-ENGINE.md`.
Ele define o fluxo decisório determinístico (Descobrir → Medir Impacto → Identificar Dono →
Classificar → Implementar) e é o ponto de entrada obrigatório das IAs. O motor **nunca** parte do
nome, **nunca** ignora o Impact Analyzer e **nunca** cria objeto sem dono.

## 12. Catálogo de Responsabilidades (Ownership)

Responder "**quem é dono do quê?**" é anterior a "onde implementar?". `OWNERSHIP-MAP.md` registra
a matriz Responsabilidade → Owner (DB-ID) e proíbe que uma IA assuma responsabilidade já dona de
outro objeto. Toda responsabilidade tem **um único owner**; novas funcionalidades são ADAPT/EXTEND
no owner ou, se não houver, PROPOSE definindo owner.

## 13. Invariantes do Sistema (leis físicas)

`SYSTEM-INVARIANTS.md` define propriedades que **sempre** devem ser verdadeiras (INV-001..INV-007:
sessão obrigatória, toda gravação auditada, runtime nasce de sessão, permissão só no Permission
Engine, frontend não chama SQL, sem fetch() direto, widget nasce de WidgetContract). Toda IA valida
os invariantes antes de implementar; violação é proibida sem justificativa e aprovação de governança.

## 14. Testes Arquiteturais (verificação das leis)

`ARCHITECTURE-TESTS.md` documenta **como verificar** as leis (AT-001..AT-004), hoje manual/estática
e automatizável em CI no futuro. Cada `AT` referencia o invariante que comprova. Falha de `AT`
bloqueia entrega até resolução ou isenção formal.

---

## 15. Decision Log, Fallback e Gates (aplicação automática)

### Decision Log

`DECISION-LOG.md` registra **decisões de engenharia** (não commits): toda saída PROPOSE/MERGE do
motor gera uma entrada `DEC-XXXX` com problema, domínio, dono, classificação, invariantes e motivo.
Ele ensina futuras IAs **como o projeto costuma decidir** e é consultado antes de reabrir decisão.

### Fallback de Ownership

`OWNERSHIP-MAP.md` define, para cada responsabilidade, **um owner e um fallback**. O fallback
garante continuidade quando o owner evolui, é substituído ou fica indisponível — a responsabilidade
permanece claramente definida.

### Gates (aplicação automática)

O `DECISION-ENGINE.md` aplica o fluxo como **gates** obrigatórios (ler DATABASE-MAP → DECISION-ENGINE
→ domínio → Impact Analyzer → Owner → Invariantes → duplicação → classificar → código). Falha em
qualquer gate bloqueia o avanço. O próximo ganho é **impor esses gates no pipeline** (CI/lint), não
ampliar a documentação — ver `ARCHITECTURE-TESTS.md` (automação).

## 16. Vinculação para IAs

```text
Kilo      → OBRIGATÓRIO antes de qualquer implementação
Gemini    → OBRIGATÓRIO antes de qualquer implementação
ChatGPT   → OBRIGATÓRIO antes de qualquer implementação
Claude    → OBRIGATÓRIO antes de qualquer implementação
Copilot   → OBRIGATÓRIO em sugestões de schema/SP/componente
```

Fluxo de governança (estende `MD-CANONICO-IA-002`):

```text
000-CONSTITUICAO-IA
  ↓
MD-CANONICO-IA-001 (Evolução Documental)
  ↓
MD-CANONICO-IA-002 (Governança Arquitetural)
  ↓
MD-CANONICO-IA-005 (Engenharia e Materialização)
  ↓
MD-CANONICO-IA-007 (este documento — Banco + Knowledge Graph)   ← NOVO
  ↓
DATABASE-MAP.md → INVENTORY.md → *MAP.md → DUPLICATION-MAP.md
  ↓
Dump SQL (Fonte da Verdade #1)
  ↓
REUSE → ADAPT → EXTEND → MERGE → PROPOSE → SQL → IMPLEMENT → VALIDATE
```

---

## 17. Regras de Proibição

```text
❌ Tratar o Knowledge Graph como verdade (ele é índice da verdade)
❌ Editar o MAP sem alterar o Dump
❌ Criar objeto sem antes ler o dump e o DATABASE-MAP.md
❌ Criar objeto só porque não achou o nome esperado
❌ Criar dashboard_* (Painel Clínico/TV Display) quando existe painel_* (REUSE)
❌ Reutilizar painel_* para Portal Enterprise (responsabilidade diferente → PROPOSE portal_*)
❌ Criar novo dispatcher quando sp_dispatcher_kernel já existe
❌ Criar nova SP de contexto quando sp_auth_contexto_* já cobre (prefira MERGE)
❌ Concentrar auth + authz + regra + persistência + auditoria numa única SP
❌ Criar conhecimento isolado (sem aresta/ID/confiança no Knowledge Graph)
❌ PROPOSE sem SQL materializado, sem Impact Analyzer e sem CHANGELOG
```

---

## 18. Atualização Contínua (Documento Vivo)

Sempre que houver evolução do dump, o Knowledge Graph deve ser atualizado na mesma entrega:

1. Nova ficha em `tables/` ou `procedures/` (com **ID canônico**, **confiança** e **maturidade**).
2. Atualizar `SP-TABLE-MAP.md` / `TABLE-SP-MAP.md` / `FRONT-SP-MAP.md` / `BACKEND-SP-MAP.md`.
3. Atualizar `CALLGRAPH.md` / grafo de impacto se houver nova cadeia ou dependência.
4. Atualizar `DUPLICATION-MAP.md` / `OWNERSHIP-MAP.md` (owner + fallback) se houver equivalência/MERGE.
5. Rodar o **Impact Analyzer** e registrar em `CHANGELOG.md` e em `DECISION-LOG.md`.

Nunca substituir o `.md` pelo SQL. Nunca resumir o `.md`. Sempre enriquecer.

---

## 19. Conclusão

O dump é a fonte oficial da verdade. O `DATABASE-MAP.md` é o mapa navegável **vinculante** e
parte do processo de engenharia. O Knowledge Graph — com IDs canônicos, confiança/maturidade,
grafo de impacto, ownership (+fallback), invariantes e Impact Analyzer — é a camada de descoberta
e governança que impede duplicação semântica entre múltiplas IAs. O `DECISION-ENGINE.md` é o
cérebro que padroniza a decisão em **gates**; o `DECISION-LOG.md` registra como o projeto decide.

```text
DUMP → AUDITORIA → DECISION-ENGINE (gates) → REUSE → ADAPT → EXTEND → MERGE → PROPOSE
     → SQL → IMPACT → VALIDATE → ARCHITECTURE-TESTS → DECISION-LOG
```

Sempre. Sem exceção.

---

Documento Canônico — MD-CANONICO-IA-007

**Esta lei torna obrigatória, para toda IA do projeto, a navegação pelo Knowledge Graph do banco
— com IDs canônicos, confiança/maturidade, grafo de impacto, ownership, invariantes e Impact
Analyzer — antes de qualquer criação ou alteração de objeto.**
