# DATABASE-MAP.md — Mapa Navegável do Banco (Fonte da Verdade #1)

> **LEI DO PROJETO.** Porta de entrada obrigatória para banco, backend, frontend e qualquer IA
> (Kilo / Gemini / ChatGPT). O SQL continua sendo a realidade; este `.md` é o índice.
> Vinculado à lei canônica **`MD-CANONICO-IA-007`** (Banco Fonte da Verdade + Knowledge Graph Vivo).
> **FROZEN v1.0** (DEC-0004): Kernel de Governança congelado — não criar novos artefatos de
> governança; foco em automatizar os gates e resolver bloqueios da plataforma.

## Origem — Fonte da Verdade × Fonte de Navegação

```text
FONTES DA VERDADE (autoridade máxima)
  • Dump SQL
  • Código
  • Documentação Canônica
        ↓
KNOWLEDGE GRAPH (docs/database/)   ← índice INTELIGENTE da verdade (não a verdade)
        ↓
INVENTÁRIOS (fichas por objeto)
        ↓
IMPLEMENTAÇÃO
```

**O Knowledge Graph NUNCA é a verdade.** Ele é um índice navegável e cruzado da verdade. O SQL é
a autoridade; o `.md` é descoberta e governança sobre essa base. Editar o MAP sem alterar o Dump
é anti-padrão.

## Representação Canônica Navegável — `bancoMysql.md`

Além do Dump SQL (`database/dump/Dump20260618.sql`), a plataforma mantém o **Banco Canônico
Navegável** em `docs/database/mysql/bancoMysql.md` (espelho em `database/dump/bancoMysql.md`). Ele
é a **Fonte Primária Navegável** do banco: o mesmo conteúdo do dump (CREATE TABLE / VIEW /
PROCEDURE / FUNCTION / FK / INDEX / JSON / eventos), porém em Markdown navegável, para reduzir o
risco de truncamento de leitura de SQL muito grande por IAs.

```text
bancoMysql.md            ← FONTE PRIMÁRIA NAVEGÁVEL (leitura obrigatória da IA)
       ↓ deriva de
Dump20260618.sql         ← FONTE DA VERDADE (autoridade física; prevalece em divergência)
       ↓ reflete
docs/database/ (KG)      ← índice cruzado da verdade (não a verdade)
```

> **Regra de prevalência:** em caso de divergência entre `bancoMysql.md` e o Dump SQL, o **Dump
> SQL prevalece** — `bancoMysql.md` é representação, não autoridade. Nenhuma IA trata
> `bancoMysql.md` como substituto do Banco Vivo; ele é a memória estrutural navegável do Banco Vivo
> para engenharia e IA. Antes de qualquer decisão de engenharia de banco, a IA DEVE consultar
> `bancoMysql.md` (e, se necessário, o Dump SQL) **antes** de assumir ausência de tabela, SP, coluna
> ou relacionamento.

### Ordem de Consulta Obrigatória (antes de qualquer materialização)

```text
1. Constituição (000-CONSTITUICAO-IA / -PLATAFORMA)
        ↓
2. GATE correspondente
        ↓
3. bancoMysql.md            ← FONTE PRIMÁRIA DO BANCO (Banco Canônico Navegável)
        ↓
4. MDs / MAPs / BRs         (interpretação arquitetural — não substitui o banco)
        ↓
5. Knowledge Graph (docs/database/)
        ↓
6. Backend
        ↓
7. Frontend
```

Em divergência, a precedência é: `bancoMysql.md` (e Dump SQL) **prevalecem** sobre MD / MAP / BR /
código. Nenhuma IA pode dizer "não existe essa tabela/procedure" sem antes ter consultado
`bancoMysql.md`.

### Registro de Auditoria Banco Vivo (obrigatório)

Toda conclusão estrutural deve registrar a consulta a `bancoMysql.md` (ver `MD-CANONICO-IA-007` §17.1):

```text
Banco consultado: bancoMysql.md
Objeto:           <nome>
Resultado:        ENCONTRADO | NÃO ENCONTRADO
Origem:           CREATE TABLE | CREATE PROCEDURE | CREATE FUNCTION | VIEW | INDEX | EVENT | JSON
Classificação:    REUSE | ADAPT | EXTEND | MERGE | PROPOSE
```

## Regra obrigatória

> **É proibido criar objeto novo (tabela, SP, function, trigger, runtime, auditoria, ledger,
> dispatcher, executor) sem antes verificar o dump e este mapa.**

Sempre que houver evolução do dump, este mapa e o Knowledge Graph devem ser atualizados.

## Fluxo obrigatório (antes de QUALQUER implementação)

```text
Dump (Fonte da Verdade)
  ↓
Auditoria (DUMP-001)
  ↓
REUSE → ADAPT → EXTEND → MERGE → PROPOSE
  ↓
SQL → IMPACT ANALYZER → IMPLEMENT → VALIDATE
```

## Algoritmo obrigatório (toda IA — ver MD-CANONICO-IA-007 §5)

```text
1.  Ler docs/database/mysql/bancoMysql.md (Fonte Primária Navegável) e, se necessário, /dump/Dump20260618.sql (Fonte da Verdade)
2.  Ler DATABASE-MAP.md
3.  Procurar TABELA existente            → usar (REUSE)
4.  Procurar TABELA EQUIVALENTE          → adaptar (ADAPT)
5.  Procurar SP existente                → reusar (REUSE)
6.  Procurar SP SEMELHANTE               → adaptar (ADAPT)
7.  Procurar DISPATCHER existente        → ligar nele
8.  Procurar EXECUTOR/AUDITORIA/RUNTIME  → usar
9.  Consultar GRAFO DE IMPACTO (TABLE-SP-MAP / CALLGRAPH)
10. Classificar e — só se necessário — PROPOSE + implementar
```

> Nunca criar objeto só porque não achou o nome esperado. Buscar por **responsabilidade**:
> mesmo nome → mesmo domínio → mesma responsabilidade → mesmo fluxo → mesmo call graph →
> mesmo contrato → mesma tabela. Só se todas falharem → PROPOSE.
>
> Classificação canônica: **REUSE → ADAPT → EXTEND → MERGE → PROPOSE**. Quando comportamentos
> relacionados já existem em objetos distintos, prefira **MERGE** (consolidar) a criar outro.

## Knowledge Graph do Sistema (camada de navegação, NÃO verdade)

O dump não é só inventário: é base de conhecimento operacional. Cada objeto tem arestas
cruzadas entre as camadas (índice da verdade — ver §1):

```text
Tabela (DB-TB-####)
  ↓
Procedure (DB-SP-####)
  ↓
Backend (BACK-####)
  ↓
Contrato (packages/contracts)
  ↓
Frontend (FRONT-####)
```

Mapas de arestas obrigatórios (sempre atualizados junto com o dump):

| Mapa | Aresta |
|---|---|
| `SP-TABLE-MAP.md` | SP → tabelas (lê / escreve / audita) |
| `TABLE-SP-MAP.md` | tabela → SPs que a consomem (grafo de impacto) |
| `FRONT-SP-MAP.md` | frontend (tsx) → SP |
| `BACKEND-SP-MAP.md` | backend service → SP |
| `DUPLICATION-MAP.md` | objeto → equivalente por responsabilidade |
| `CALLGRAPH.md` | cadeias reais (frontend → SP → tabela → evento → ledger → worker) |

Exemplo de aresta:

```text
sessao_usuario (DB-TB-0257)
    ├── sp_master_login (DB-SP-0001) ── LoginController / AuthService / SessionResolver / LoginPage.tsx
    ├── sp_auth_contexto_get (DB-SP-0002) ── ContextService / ContextSelectionPage.tsx
    └── sp_auth_menu_get (DB-SP-0003) ── PortalService / PortalRuntimeProvider / EnterpriseShell
```

### ID Canônico (independente de nome)

Todo objeto recebe um ID estável (`DB-SP-####`, `DB-TB-####`, `DB-FN-####`, `DB-VW-####`,
`BACK-####`, `FRONT-####`, `RT-####`). O nome pode mudar; o ID não. Registrado nas fichas e
referenciado nos `*MAP.md`.

### Níveis de Confiança e Maturidade

Cada objeto declara **confiança** (cobertura de fontes, ★ = 1..5) e **maturidade** (prontidão
para produção). Ausente no Dump ⇒ no máximo ★★ ⇒ exige PROPOSE + SQL.

```text
DB-SP-0007  sp_auth_menu_get
  Confiança: ★★★★★   Maturidade: Enterprise   Status: Produção

DB-SP-0042  sp_auth_permissions_evaluate
  Confiança: ★        Maturidade: Planned     Status: CORE-005 (proposto)
```

Escala Maturidade: `PLANNED → PROTOTYPE → BETA → PRODUCTION → ENTERPRISE`.
Status: `PRODUÇÃO | CORE-XXX | PROPOSTO | BLOQUEADO | MERGE-PENDENTE`.

## Pipeline canônico de execução

Toda escrita de negócio segue responsabilidades únicas, com `EntryPoint` e `Domain Rules` explícitos:

```text
EntryPoint → Master → Guardião → Policy → Permission Evaluate → Orquestrador → Dispatcher
          → Executor → Domain Rules → Auditoria → Evento → Ledger → Snapshot → Runtime
```

- `Guardião` valida **integridade**; `Policy` aplica **políticas globais** (feature flags,
  licenciamento, plano SaaS, manutenção, regras institucionais); `Permission` decide
  **autorização específica**. A separação escala para múltiplos produtos/tenants.
- `Domain Rules` deixa explícito onde ficam as regras de negócio; o Executor não as carrega.
- Nenhuma SP concentra auth + policy + authz + regra + persistência + auditoria.
- Dispatcher existente (`sp_dispatcher_kernel`, `sp_master_*`, `sp_executor_*`) é **REUSE**.
- Auditoria/Evento/Ledger/Runtime existentes são **REUSE**.

## Grafo de Impacto (dependências)

O KG representa **dependências**, não só consumo. Alterar uma tabela revela o impacto imediato.

```text
sp_master_login (DB-SP-0001)
  ↓ Depende de
  usuario · login_tentativa · sessao_usuario · usuario_contexto · auditoria_evento
```

Alterar `usuario_contexto` ⇒ impacto imediato em `sp_master_login`, `sp_auth_contexto_get`,
`sp_auth_contexto_set`. É a base do Impact Analyzer.

## Impact Analyzer (obrigatório antes de alterar)

Toda alteração começa por medir impacto, nunca por código:

```text
Quero alterar: painel (DB-TB-0101)
  ↓ TABLE-SP-MAP → CALLGRAPH → BACKEND-SP-MAP → FRONT-SP-MAP → runtime/
  ↓ Resultado:
  Impacto = 7 procedures · 3 services · 2 páginas · 1 runtime · 2 contratos
```

Só após conhecer o impacto a IA escreve código; o resultado vai para `CHANGELOG.md`.

## Estrutura deste mapa (Knowledge Graph)

```text
docs/database/
├── DATABASE-MAP.md        ← ESTE ARQUIVO (lei + índice)
├── DECISION-ENGINE.md     ← cérebro da engenharia (fluxo decisório + gates)
├── DECISION-LOG.md        ← histórico de decisões arquitetônicas (DEC-0001..)
├── OWNERSHIP-MAP.md       ← catálogo de responsabilidades (owner + fallback)
├── SYSTEM-INVARIANTS.md   ← leis físicas do sistema (INV-001..)
├── ARCHITECTURE-TESTS.md  ← verificação das leis (AT-001..)
├── INVENTORY.md           ← algoritmo obrigatório pré-implementação
├── SP-TABLE-MAP.md        ← SP → tabelas (lê/escreve/audita)
├── TABLE-SP-MAP.md        ← tabela → SPs que a usam (grafo de impacto)
├── DUPLICATION-MAP.md     ← regra de não-duplicação
├── FRONT-SP-MAP.md        ← frontend → SP
├── BACKEND-SP-MAP.md      ← backend service → SP
├── CHANGELOG.md           ← registro de mudanças (com Impact Analyzer)
├── tables/                ← ficha por tabela (ID canônico + confiança + maturidade)
├── tables_completas/      ← ficha completa por tabela
├── tables_raw/            ← definição bruta (JSON) por tabela
├── procedures/            ← ficha por SP (ID canônico + confiança + maturidade) + functions
├── functions/             ← índice de funções
├── runtime/               ← índice de runtime/kernel
├── modules/               ← DOMAINS.md (decomposição de domínios)
├── callgraph/             ← CALLGRAPH.md (cadeias reais)
└── views/                 ← kilo-views.json
```

## Domínios (ver modules/DOMAINS.md)

IAM · Portal · Fila/Senha · Kernel/Runtime · Assistencial · Farmácia/FFA · Estoque ·
Faturamento · Laboratório · Pessoas · Auditoria · Documentos · Infraestrutura ·
Qualidade/Regulação · Financeiro/PDV · Workflow/Eventos · Referência (MD/SIGTAP).

## Exemplos de não-duplicação (ver DUPLICATION-MAP.md)

- Não criar `dashboard`/`dashboard_widget`: usar família `painel_*`.
- Não criar nova SP de contexto: `sp_auth_contexto_get/set`, `sp_sessao_contexto_get` e
  `sp_master_login` (AUTH.CONTEXTO.*) já cobrem — prefira **MERGE**.
- Não criar novo dispatcher: `sp_dispatcher_kernel`, `sp_master_*` e `sp_executor_*` já existem.

## Artefatos do Kernel Enterprise

| Artefato | Papel |
|---|---|
| `DECISION-ENGINE.md` | cérebro da engenharia — fluxo decisório determinístico + **gates** |
| `DECISION-LOG.md` | histórico de decisões (DEC-0001..) — como o projeto decide |
| `OWNERSHIP-MAP.md` | quem é dono de cada responsabilidade (+ fallback) |
| `SYSTEM-INVARIANTS.md` | leis físicas (INV-001..) que nunca podem ser violadas |
| `ARCHITECTURE-TESTS.md` | como verificar as leis (AT-001..) e automatizá-las em CI |

## Lei canônica vinculante

Este índice é regido por **`docs/canonical/MD-CANONICO-IA-007.md`**. Qualquer IA (Kilo, Gemini,
ChatGPT, Claude, Copilot) deve passar pelo `DECISION-ENGINE.md` (algoritmo §5) antes de propor ou
criar qualquer objeto, respeitando `OWNERSHIP-MAP.md`, `SYSTEM-INVARIANTS.md` e `ARCHITECTURE-TESTS.md`.
