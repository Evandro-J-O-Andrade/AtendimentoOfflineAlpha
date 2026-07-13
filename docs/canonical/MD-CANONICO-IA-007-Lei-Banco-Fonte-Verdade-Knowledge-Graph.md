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

### 1.1 Representação Canônica Navegável — `bancoMysql.md`

A plataforma mantém o **Banco Canônico Navegável** em `docs/database/mysql/bancoMysql.md` (espelho
em `database/dump/bancoMysql.md`): o mesmo conteúdo do Dump SQL, em Markdown navegável, para
reduzir o risco de truncamento de leitura de SQL muito grande por IAs. Ele é a **Fonte Primária
Navegável** do banco e **não substitui o Banco Vivo** — a fonte da verdade continua sendo o SQL
(`database/dump/Dump20260618.sql`), que prevalece em caso de divergência. Toda IA deve consultá-lo
obrigatoriamente antes de propor tabela/SP/migration/ADAPT, e **é proibido** assumir ausência de
tabela, SP, coluna ou relacionamento sem antes consultá-lo.

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
 1.  Ler docs/database/mysql/bancoMysql.md (Fonte Primária Navegável) e, se necessário, /dump/Dump20260618.sql (Fonte da Verdade)
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
❌ Criar componente de Runtime (RuntimeService / Runtime Queue / Event Bus / Lock Manager / Health Manager) quando o Banco Vivo já possui Kernel Runtime materializado (runtime_* / kernel_* / sp_dispatcher_kernel / sp_guardiao_runtime_assert / sp_executor_* / sp_sessao_assert) → REUSE ou ADAPT, nunca PROPOSE
❌ Propor evolução de Runtime/Kernel sem antes auditar bancoMysql.md (origem: CREATE PROCEDURE / FUNCTION / TABLE / VIEW / EVENT) e registrar a classificação (REUSE/ADAPT/EXTEND/MERGE/PROPOSE)
```

---

## 17.1 Auditoria Banco Vivo (registro obrigatório antes de qualquer conclusão estrutural)

Toda conclusão estrutural (existência/ausência de tabela, SP, function, view, coluna, FK, índice)
deve ser precedida de consulta a `bancoMysql.md` e registrada no formato abaixo. Isso torna a
decisão rastreável e obriga qualquer IA a justificar tecnicamente uma proposta (PROPOSE).

```text
AUDITORIA BANCO VIVO

Banco consultado:   bancoMysql.md
Objeto:             <nome>
Resultado:          ENCONTRADO | NÃO ENCONTRADO
Origem:             CREATE TABLE | CREATE PROCEDURE | CREATE FUNCTION | VIEW | INDEX | EVENT | JSON
Classificação:      REUSE | ADAPT | EXTEND | MERGE | PROPOSE
```

Exemplos:

```text
AUDITORIA
Objeto:    sp_guardiao_runtime_assert
Resultado: ENCONTRADO
Origem:    CREATE PROCEDURE
Classificação: REUSE
```

```text
AUDITORIA
Objeto:    runtime_registry
Resultado: NÃO ENCONTRADO
Classificação: PROPOSE
```

Em divergência entre documentação (MD/MAP/BR) e `bancoMysql.md`, **prevalece `bancoMysql.md`**.
Nenhuma IA pode afirmar "não existe" sem registrar a auditoria acima como NÃO ENCONTRADO.

---

## 17.2 Modo de Trabalho Audit-First do KILO (nunca começa implementando)

Toda tarefa do KILO obedece à ordem: **audita antes de materializar**. O KILO atua como
auditor/engenheiro do banco, não apenas gerador de código.

```text
Constituição
        ↓
GATE
        ↓
bancoMysql.md            ← CONSULTA OBRIGATÓRIA (Fonte Primária do Banco Vivo)
        ↓
AUDITORIA
        ↓
REUSE → ADAPT → EXTEND → MERGE → PROPOSE
        ↓
Só então materializa (com aprovação de GATE)
```

Capacidades de auditoria (todas registradas no formato §17.1):

1. Verificar existência (tabela/SP/function/view/índice/FK/JSON/event/trigger) → ENCONTRADO ⇒ REUSE.
2. Procurar equivalente por responsabilidade/família (nome diferente) → ADAPT.
3. Procurar regra semelhante (MD/MAP/BR/ADR/Capability) → EXTEND.
4. Existe no banco, mas não na documentação → gerar MD automaticamente.
5. Existe na documentação, mas não no banco → PROPOSE.
6. Verificar duplicidade (SP/componente com mesma responsabilidade) → não criar (MERGE).
7. Verificar impacto (quem consome: SP/view/FK/JSON/frontend/backend/runtime).
8. Descobrir órfãos (SP nunca chamada, tabela não usada, Capability sem Runtime, Runtime sem
   Master, Master sem Executor, Executor sem SP).
9. Descobrir melhorias.
10. Verificar aderência à Constituição (Lei / GATE / IA-007 / FREEZE / Banco Vivo / Registry / KG).

### Regra MD-PROPOSE-XXX (propostas nunca são auto-implementadas)

Toda vez que a auditoria encontrar uma oportunidade de melhoria que **não existe no Banco Vivo nem
na documentação canônica**, o KILO **não implementa**. Ele gera um documento `MD-PROPOSE-XXX`
(título, justificativa, impacto, dependências, classificação PROPOSE, necessidade de aprovação no
GATE) e aguarda aprovação. Nenhuma linha de código/SQL é escrita sem GATE.

### Resultado padrão de auditoria

```text
AUDITORIA
Objeto:                <nome>
Banco:                 CONSULTADO (bancoMysql.md)
Documentação:          CONSULTADA
Knowledge Graph:       CONSULTADO
Resultado:             REUSE | ADAPT | EXTEND | MERGE | PROPOSE
Itens reutilizados:    ...
Itens adaptados:       ...
Itens estendidos:      ...
Itens fundidos:        ...
Itens inexistentes:    ...
Melhorias propostas:   MD-PROPOSE-0XX
Implementação:         NÃO EXECUTADA
```

---

## 17.3 Auditor de Engenharia (papel do KILO após a auditoria inicial)

O KILO atua como **Auditor → Arquiteto → só depois Implementador**. Para qualquer alteração, ele
**compara e classifica; não implementa**. O objetivo é impedir componentes paralelos/redundantes.

### Fluxo de comparação (antes de concluir)

```text
1. Ler Constituição
2. Ler GATE relacionado
3. Ler bancoMysql.md            (Fonte Primária do Banco Vivo)
4. Ler MDs relacionados
5. Ler Backend
6. Comparar
7. Responder:
     EXISTE | NÃO EXISTE | SIMILAR | DIVERGENTE | OBSOLETO | REDUNDANTE | MELHORIA
```

### Formato padrão de ACHADO

Todo achado é registrado assim (ver `GATE-CONTEXT-RESOLVER.md`):

```text
ACHADO
Objeto:        <nome>
Status:        ENCONTRADO | DIVERGENTE | NÃO ENCONTRADO | SIMILAR | OBSOLETO | REDUNDANTE
Motivo:        <por que>
Classificação: REUSE | ADAPT | EXTEND | MERGE | PROPOSE
Impacto:       <CORE-XXX / Discovery / Infrastructure Runtime / ...>
Justificativa: <obrigatória quando PROPOSE>
```

### Busca de equivalências (evitar falso negativo)

Ao verificar existência, o KILO **sempre** procura pela família do domínio, não só pelo nome
exato. Para "Runtime Registry", por exemplo, deve buscar:

```text
runtime · registry · catalog · metadata · configuration · engine · dispatcher · kernel · executor
```

Muitas vezes o Banco Vivo já possui a funcionalidade com outro nome → REUSE/ADAPT, nunca PROPOSE.

### Seção CONCLUSÃO (obrigatória em toda auditoria)

```text
CONCLUSÃO
REUSE    <n>
ADAPT    <n>
EXTEND   <n>
MERGE    <n>
PROPOSE  <n>

DECISÃO
Não criar novo componente. Adaptar componentes existentes.
```

---

## 17.4 Protocolo de Auditoria do Banco (algoritmo obrigatório)

> **Este protocolo NÃO é recomendação: é um ALGORITMO OBRIGATÓRIO** para qualquer atividade de
> engenharia. Toda decisão de criar/adaptar/reutilizar componente deve seguir esta sequência
> determinística sobre a fonte primária (`bancoMysql.md`), com evidência e classificação
> padronizadas. Isso elimina interpretações divergentes entre agentes.

A fonte de verdade do projeto **não é a documentação** — é o Banco Vivo. `bancoMysql.md` contém o
SQL completo (do primeiro `CREATE` ao fim) e é a **referência operacional principal**. MD/MAP/BR/KG
interpretam o banco; nunca o substituem.

> (Constituição e GATEs governam o **processo** — quando/como agir; `bancoMysql.md` é a fonte da
> **verdade** para o que existe ou não no banco.)

### Hierarquia da Fonte da Verdade

```text
1.  bancoMysql.md            ← FONTE PRIMÁRIA (SQL completo do Banco Vivo)
2.  Dump SQL                 (validação de sintaxe / localização rápida)
3.  Constituição
4.  GATEs
5.  MD
6.  MAP
7.  BR
8.  Knowledge Graph
9.  Backend
10. Frontend
```

> **Nunca** concluir que algo existe ou não existe apenas porque um MD diz isso. Primeiro procurar
> em `bancoMysql.md`.

### Princípio da Evidência

```text
É PROIBIDO concluir:
  • NÃO EXISTE
  • AUSENTE
  • PROPOSE
sem registrar a evidência da auditoria.

Toda conclusão deve conter:
  Objeto
  Fonte consultada
  Resultado
  Classificação
  Justificativa
```

Assim qualquer PROPOSE fica rastreável.

### Princípio da Busca Semântica

Não basta procurar o nome. O algoritmo pesquisa automaticamente:

```text
Nome → Plural → Singular → Prefixos → Sufixos → Abreviações
     → Sinônimos técnicos → Sinônimos de negócio → Objetos relacionados
```

Exemplo:

```text
Capability → Permission → Permissao → ACL → Guardian → Perfil → Role
```

Isso evita falsos "NÃO ENCONTRADO".

### Princípio da Classificação

```text
Objeto → Encontrou?
  SIM → REUSE | ADAPT | EXTEND | MERGE
  NÃO → PROPOSE
```

> **PROPOSE deixa de ser hipótese e passa a ser o ÚLTIMO resultado possível do algoritmo.**

### Fluxo permanente

```text
INÍCIO
   ↓ Constituição
   ↓ GATE
   ↓ Consultar bancoMysql.md
   ↓ Pesquisar literal
   ↓ Pesquisar sinônimos
   ↓ Pesquisar estrutura (Tabelas/SPs/Views/FKs/JSON/ENUM)
   ↓ Pesquisar relacionamentos
   ↓ Encontrou?
        SIM → REUSE | ADAPT | EXTEND | MERGE
        NÃO → Registrar evidência → PROPOSE
   ↓ Atualizar MD/MAP/BR
   ↓ GATE
   ↓ Implementação
```

### REGRA — antes de escrever "NÃO EXISTE"

```text
Obrigatório pesquisar ANTES de concluir NÃO ENCONTRADO:
  • nome / plural / singular
  • prefixos / sufixos
  • sinônimos
  • tabelas relacionadas (FK)
  • procedures relacionadas
  • views / índices
  • JSON / ENUM
  • comentários
  • objetos do mesmo domínio
```

A busca é **semântica, não literal**. Ex.: procura "tenant" → não acha → procura `saas_tenant`,
`tenant_registry`, `tenant_entidade`, `saas_entidade`, `entidade`, `empresa`, `organizacao`,
`cliente`, `id_entidade` → encontra `saas_entidade`/`id_entidade` (REUSE). Só após busca ampliada
pode escrever **NÃO ENCONTRADO** → PROPOSE.

> `bancoMysql.md` é a fonte de verdade operacional. MD/MAP/BR/KG são interpretação e documentação
> do banco — nunca a fonte primária. Isso evita concluir incorretamente que algo "não existe" e
> reduz a criação de componentes duplicados.

---

## 17.5 Princípio da Materialização

O projeto evoluiu de um fluxo **documental** (`MD → MAP → BR → Implementação`) para um fluxo
**orientado por evidências**: os documentos registram a decisão tomada a partir de uma auditoria —
**não a originam**.

```text
PRINCÍPIO DA MATERIALIZAÇÃO

Nenhum documento canônico cria existência.
MD, MAP, BR, ADR e GATE apenas descrevem, classificam ou governam objetos.
A existência só é considerada materializada quando houver EVIDÊNCIA NA FONTE PRIMÁRIA.
```

```text
Ordem de materialização:
  Banco Vivo
    ↓ bancoMysql.md
    ↓ Dump SQL
    ↓ Evidência
    ↓ MD / MAP / BR
    ↓ Backend
    ↓ Frontend
```

Consequências:

```text
• Um MD nunca prova que uma tabela existe.
• Um ADR nunca prova que uma SP existe.
• Um MAP nunca prova que um Runtime existe.
• Um BR nunca prova que uma regra já está implementada.
Eles apenas documentam.
```

### Estados Canônicos

Cada objeto auditado tem quatro estados distintos:

| Estado | Significado |
| --- | --- |
| **CONCEITO** | Existe apenas na arquitetura/documentação. |
| **MATERIALIZADO** | Existe fisicamente no Banco Vivo (evidência em `bancoMysql.md`/SQL). |
| **CONSUMIDO** | Backend ou Frontend já utilizam o objeto. |
| **CONFORME** | Implementação corresponde ao contrato canônico. |

Exemplos:

```text
Capability Registry
  Conceito       ✅
  Materializado  ❌
  Consumido      ❌
  Conforme       —
```

```text
sp_master_login
  Conceito       ✅
  Materializado  ✅
  Consumido      ✅
  Conforme       ⚠ ADAPT
```

### Índice de Maturidade

Toda auditoria termina com o mesmo padrão:

```text
Objeto
  ↓ Conceito
  ↓ Materializado
  ↓ Consumido
  ↓ Conforme
  ↓ Classificação: REUSE | ADAPT | EXTEND | MERGE | PROPOSE
```

Assim um objeto pode ser:

```text
Conceito       ✅
Materializado  ✅
Consumido      ❌
Conforme       ⚠
Classificação: ADAPT
```

ou

```text
Conceito       ✅
Materializado  ❌
Consumido      ❌
Classificação: PROPOSE
```

> Com `CONCEITO / MATERIALIZADO / CONSUMIDO / CONFORME` o processo separa nitidamente: (1) Governança
> (Constituição, GATEs, MDs, ADRs, MAPs, BRs); (2) Evidência (Banco Vivo, `bancoMysql.md`, Dump SQL);
> (3) Implementação (Backend, Frontend, Runtime); (4) Consumo (serviços/módulos que usam os
> componentes). Toda decisão de engenharia é auditável: primeiro a evidência na fonte primária,
> depois o estado do objeto, só então REUSE/ADAPT/EXTEND/MERGE/PROPOSE.

---

## 17.6 Formato Padrão de GATE e Confiança da Evidência

A engenharia do projeto agora tem quatro camadas: (1) **Governança** (Constituição, GATEs, MD, ADR,
MAP, BR); (2) **Evidência** (Banco Vivo, `bancoMysql.md`, Dump SQL); (3) **Engenharia** (Auditoria →
Classificação → Plano de ADAPT → Implementação); (4) **Execução** (Backend, Frontend, Runtime, SP,
Banco). Isso separa documentação de implementação.

Todo GATE (e toda auditoria) obedece a um **quadro homogêneo**, qualquer que seja o domínio
(Runtime, Discovery, Auth, Estoque, Farmácia...). Garante reprodutibilidade entre agentes.

### Quadro Padrão de GATE

```text
OBJETO           <nome>

CONCEITO         ✅ / ❌
MATERIALIZADO    ✅ / ❌   (Fonte: Banco Vivo / bancoMysql.md)
CONSUMIDO        Backend: ✅/❌ · Frontend: ✅/❌ · Runtime: ✅/❌
CONFORME         SIM / PARCIAL / NÃO

CLASSIFICAÇÃO    REUSE | ADAPT | EXTEND | MERGE | PROPOSE

EVIDÊNCIA        Tabela/SP/View + Linha + Arquivo
CONFIANÇA        ALTA (Banco Vivo/bancoMysql.md) · MÉDIA (Dump antigo/Backend) · BAIXA (MD)

DECISÃO          GATE ACCEPTED | REJECTED
```

### Confiança da Evidência

Nem toda evidência tem o mesmo peso. Campo obrigatório:

| Fonte | Confiança |
| --- | --- |
| Banco Vivo | ALTA |
| `bancoMysql.md` | ALTA |
| Dump SQL antigo | MÉDIA |
| Backend | MÉDIA |
| MD / MAP / BR | BAIXA |

> Um objeto encontrado no Banco Vivo tem mais força do que uma descrição em MD. Cadeia
> determinística: Necessidade → Constituição → GATE → Auditoria → `bancoMysql.md` → Banco Vivo →
> Evidência → Estados Canônicos → Classificação → Plano de ADAPT → Implementação → Novo GATE → Aceite.

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
