# CHANGELOG.md — Registro de Mudanças de Schema/SP

> Regra: toda criação/alteração de tabela, SP, função ou contrato deve gerar uma entrada aqui,
> com classificação REUSE/ADAPT/EXTEND/PROPOSE e referência (CORE/FRONT/MD).

## 2026-07-09 — FREEZE Kernel de Governança v1.0 (DEC-0004)

- **Ação:** Congelar a governança e redirecionar para a plataforma
- **Classificação:** FREEZE (DEC-0004 no `DECISION-LOG.md`)
- **Regra de congelamento:** nenhum novo documento de governança sem lacuna real não resolvível
  pelos artefatos existentes
- **Marcos:** `IA-007` e `DATABASE-MAP.md` marcados como **FROZEN v1.0**
- **Contrato máquina:** `DECISION-ENGINE.json` (derivado de `DECISION-ENGINE.md`) para CI/tooling
- **Métricas de cumprimento** registradas (REUSE/PROPOSE/MERGE Rate, Impact Coverage, Gate
  Compliance, Invariant Compliance, Architectural Debt)
- **Bloqueios conhecidos a atacar:** CORE-005 (`sp_auth_permissions_evaluate`), `WidgetRenderer`,
  Runtime de Painéis (`painel_*` → `WidgetContract[]`), Permission Runtime, Runtime Enterprise
- **Verificado:** `sp_auth_permissions_evaluate` ausente no Dump; `WidgetRenderer` inexistente;
  `WidgetContract`/`WidgetResolver`/`PortalRuntimeEngine` existem

## 2026-07-09 — Refinamentos de governança (sem novos docs) + CORE-005 materializado

- **Ação:** Refinar artefatos existentes (sem criar documentação nova) e iniciar bloqueios da plataforma
- **Classificação:** EXTEND (governança) + PROPOSE (CORE-005 SQL)
- **Governança (edits em IA-007 / DECISION-ENGINE):**
  - Busca por **FAMÍLIA** de responsabilidade (dashboard→painel_*, auth→auth_*/sessao_*/usuario_*, etc.)
  - Princípio de **artefato derivado**: tudo em `docs/database/` é regenerável do Dump + Código
  - Rótulos do pipeline alinhados: Master Procedure / Policy Engine / Business Orchestrator / Snapshot Runtime
  - `DECISION-ENGINE.md`: seção "Prompt obrigatório" (TASK→DATABASE-MAP→OWNERSHIP→SP-TABLE-MAP→CALL-GRAPH→DECISION-ENGINE→IMPLEMENTAÇÃO)
  - `DECISION-ENGINE.json`: `familySearch` + `derivedArtifacts` (habilita automação/CI)
- **CORE-005 (PROPOSE → SQL):**
  - Criado `database/migrations/proposed/MD-CORE-005-sp_auth_permissions_evaluate.sql` (STATUS: PROPOSED / REQUIRE APPROVAL)
  - ADAPT de `sp_auth_menu_get`; pipeline Master Procedure → Guardião → Permission Evaluate
  - Contrato respeitado: `PermissionService.evaluate` → `CALL sp_auth_permissions_evaluate(?, @permissions)`
  - Respeita INV-001 (sessão) e INV-004 (permissão só no engine)
  - Próximo: mover para `approved/` após revisão

## 2026-07-09 — Ajuste de filosofia da hierarquia de verdade + métricas de auditoria

- **Ação:** Refinar artefatos existentes (sem novos documentos) conforme auditoria técnica
- **Classificação:** EXTEND (governança já congelada em v1.0)
- **Hierarquia de verdade (`IA-007 §1`):** Dump SQL **e** Código como verdades físicas co-iguais;
  Knowledge Graph explicitamente **derivado** de ambos; Documentação Canônica = arquitetura
  desejada (não fonte física). Ex.: `sp_auth_menu_get` existe no Dump, mas quem a usa
  (`PortalService`→`PortalApi`→`PortalRuntimeProvider`→`EnterpriseShell`) só aparece no Código.
- **Pipeline (`IA-007 §9`):** regra "Master orquestra apenas" — contexto pertence a
  `sp_master_contexto`→`sp_auth_contexto_*`, menu a `sp_master_menu`→`sp_auth_menu_get`;
  `sp_master_login` concentra só autenticação (via MERGE / DUMP-001 DUP-1/DUP-2).
- **Métricas (`DECISION-LOG` DEC-0004):** alinhadas à auditoria — REUSE/MERGE/PROPOSE Rate,
  Impact Coverage, Decision Compliance (Gates 1–9), Runtime Coverage, SP Coverage.
- **Decisão:** governança madura o suficiente; próximo retorno é materialização da plataforma
  (CORE-005 integrado, WidgetRenderer, `painel_*`→`WidgetContract[]`, `runtime_*`/`kernel_*`).



## 2026-07-09 — Decision Log, Fallback e Gates (IA-007 v4)

- **Ação:** Criar `DECISION-LOG.md` e reforçar governança como gates; evitar novos documentos
- **Classificação:** EXTEND (sobre IA-007 v3)
- **Novos artefatos:** `DECISION-LOG.md` (histórico de decisões DEC-0001.., não commits)
- **Mudanças:**
  - `OWNERSHIP-MAP.md`: adicionado **Fallback** (owner + substituto) em toda responsabilidade
  - `DECISION-ENGINE.md`: fluxo apresentado como **gates** obrigatórios (GATE 1..9)
  - `ARCHITECTURE-TESTS.md`: seção de **automação da governança** (CI/lint/prompts padronizados)
  - `IA-007 §15`: Decision Log + Fallback + Gates; conclusão e fluxo atualizados
  - `DATABASE-MAP.md`: árvore e tabela de artefatos com DECISION-LOG e gates
- **Decisão de escopo:** NÃO criar mais documentos — retorno agora vem de **automatizar os gates**
- **Referência:** `MD-CANONICO-IA-007` §15, `DECISION-LOG.md`, `ARCHITECTURE-TESTS.md`

## 2026-07-09 — Artefatos do Kernel Enterprise (IA-007 v3)

- **Ação:** Criar 4 artefatos de governança em `docs/database/` e estender IA-007
- **Classificação:** EXTEND (sobre IA-007 Kernel Enterprise)
- **Novos artefatos:**
  - `DECISION-ENGINE.md` — fluxo decisório explícito (o cérebro da engenharia)
  - `OWNERSHIP-MAP.md` — catálogo de responsabilidades (quem é dono do quê)
  - `SYSTEM-INVARIANTS.md` — leis físicas INV-001..INV-007
  - `ARCHITECTURE-TESTS.md` — verificação AT-001..AT-004 (automatizável em CI)
- **Mudanças em IA-007:** Maturidade+Status ao lado da Confiança; camada **Policy** entre
  Guardião e Permission no pipeline; seções §11–§14 para os novos artefatos
- **Mudanças em DATABASE-MAP.md:** árvore ampliada, pipeline com Policy, Maturidade, refs
- **Referência:** `MD-CANONICO-IA-007` §11–§14, §9

## 2026-07-09 — Refinamento IA-007 (Kernel Enterprise)

- **Ação:** Elevar IA-007 ao nível Kernel Enterprise
- **Classificação:** EXTEND (sobre a lei criada na entrada anterior)
- **Mudanças:**
  - Separar **Fonte da Verdade** (Dump/Código/Doc Canônica) de **Fonte de Navegação** (Knowledge Graph)
  - **Níveis de Confiança** (★ 1..5 por cobertura de fontes) em toda ficha
  - **ID Canônico** estável (`DB-SP-####`, `DB-TB-####`, `FRONT-####`, `BACK-####`, `RT-####`)
  - Etapa **MERGE** na classificação: REUSE→ADAPT→EXTEND→MERGE→PROPOSE
  - **Grafo de Impacto** (dependências SP→tabela) e **Impact Analyzer** obrigatório antes de alterar
  - Pipeline com `EntryPoint` e `Domain Rules`: EntryPoint→Master→Guardião→Permission→Orquestrador→
    Dispatcher→Executor→Domain Rules→Auditoria→Evento→Ledger→Snapshot→Runtime
- **Vincula:** `DATABASE-MAP.md` (atualizado), `INVENTORY.md`, `*MAP.md`
- **Referência:** `MD-CANONICO-IA-007` §1–§9

## 2026-07-09 — Lei Canônica IA-007 (Banco + Knowledge Graph Vivo)

- **Ação:** Criar `docs/canonical/MD-CANONICO-IA-007-Lei-Banco-Fonte-Verdade-Knowledge-Graph.md`
- **Classificação:** PROPOSE (nova lei canônica vinculante para toda IA)
- **Conteúdo:** eleva `docs/database/` de "inventário" a Knowledge Graph obrigatório; codifica o
  algoritmo de 9 passos pré-implementação, o pipeline Master→Guardião→...→Runtime Snapshot e a
  regra de não-duplicação semântica (REUSE→ADAPT→EXTEND→PROPOSE)
- **Vincula:** `DATABASE-MAP.md`, `INVENTORY.md`, `*MAP.md`, `DUPLICATION-MAP.md`
- **Referência:** `MD-CANONICO-IA-005` (Materialização), `MD-CANONICO-IA-002` (Governança)

## 2026-07-09 — Criação do Inventário Vivo

- **Ação:** Criar `docs/database/` (INVENTORY, DATABASE-MAP, TABLES, PROCEDURES, FUNCTIONS,
  CALL-GRAPH, DOMAINS, RUNTIME, FRONTEND, BACKEND, CHANGELOG e *MAP.md)
- **Classificação:** REUSE (estrutura já existia no dump/código; apenas documentada)
- **Fonte:** `database/dump/Dump20260618.sql` + árvore de código
- **Referência:** FASE 0.1 / FASE 0.2 / DUMP-001

## 2026-07-09 — Auditoria DUMP-001 (seed Auth/Portal/Runtime)

- **Ação:** Auditar SPs fornecidas contra o dump
- **Resultado:** 6/7 SPs existem (REUSE); padrão Master+Executors já existe no dump
- **Classificação:** REUSE (6) · PROPOSE/ADAPT (1: `sp_auth_permissions_evaluate`)
- **Referência:** `docs/database/DUMP-001-audit.md`

## 2026-07-09 — BLOQUEIO: sp_auth_permissions_evaluate

- **Ação:** SP chamada por `PermissionService` está **ausente** no dump
- **Classificação:** ADAPT (a partir de `sp_auth_menu_get`)
- **Origem:** `sp_auth_menu_get`
- **Referência:** CORE-005 · `docs/database/procedures_raw_texts/sp_auth_permissions_evaluate.sql`
- **Status:** Pendente materialização no banco

## 2026-07-09 — Duplicação de Contexto (DUP-1/DUP-2)

- **Ação:** Contexto GET/SET existe em `sp_auth_contexto_get/set`, `sp_sessao_contexto_get` e
  nos ramos `AUTH.CONTEXTO.*` de `sp_master_login`
- **Classificação:** ADAPT (consolidar em Master + Executors; não criar nova SP)
- **Referência:** `docs/database/DUMP-001-audit.md` R2

## 2026-07-09 — Backend: router duplicado

- **Ação:** `backend/src/routes/auth.ts` define o router duas vezes
- **Classificação:** ADAPT (remover duplicata)
- **Referência:** `docs/database/DUMP-001-audit.md` R3
