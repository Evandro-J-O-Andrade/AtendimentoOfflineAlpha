# INVENTORY.md — Inventário Vivo do Projeto

> **Fonte da verdade #4** (ao lado de Dump, Código e Documentação).
> Local real: `docs/database/INVENTORY.md` (não `docs/engineering/inventory/`).
> Gerado a partir de `database/dump/Dump20260618.sql` (banco real) + árvore de código.
> Este inventário é **obrigatório e vivo**: qualquer IA (Kilo/Gemini/ChatGPT/Claude/Copilot)
> deve lê-lo antes de propor ou criar qualquer objeto.
> Vinculado à lei canônica **`MD-CANONICO-IA-007`** (Banco Fonte da Verdade + Knowledge Graph Vivo).

## Estrutura (Knowledge Graph — `docs/database/`)

```text
docs/database/
├── INVENTORY.md        (este índice + regra obrigatória)
├── DATABASE-MAP.md     (porta de entrada obrigatória / lei)
├── SP-TABLE-MAP.md     (SP → tabelas: lê/escreve/audita)
├── TABLE-SP-MAP.md     (tabela → SPs que a consomem)
├── FRONT-SP-MAP.md     (frontend tsx → SP)
├── BACKEND-SP-MAP.md   (backend service → SP)
├── DUPLICATION-MAP.md  (regra de não-duplicação por responsabilidade)
├── CHANGELOG.md        (toda mudança de schema/SP com classificação)
├── tables/             (ficha por tabela)
├── procedures/         (ficha por SP)
├── functions/          (índice de funções)
├── runtime/            (runtime_* / kernel_*)
├── modules/DOMAINS.md  (decomposição de domínios)
└── callgraph/          (CALLGRAPH.md: quem chama quem)
```

## Regra obrigatória (execute antes de qualquer alteração)

```text
1. Ler DECISION-ENGINE.md (cérebro da engenharia)
2. Consultar DATABASE-MAP.md / *MAP.md → procurar tabela existente
3. Consultar procedures/ → procurar SP existente
4. Consultar CALLGRAPH.md / TABLE-SP-MAP.md → grafo de impacto (quem chama quem)
5. Rodar IMPACT ANALYZER (TABLE-SP-MAP → CALLGRAPH → BACKEND → FRONTEND → RUNTIME)
6. Consultar OWNERSHIP-MAP.md → quem é o dono da responsabilidade?
7. Validar SYSTEM-INVARIANTS.md (INV-001..)
8. Classificar:
      REUSE    (existe igual)
      ADAPT    (existe com outro nome / pode ser adaptado)
      EXTEND   (existe parcialmente)
      MERGE    (comportamentos relacionados espalhados → consolidar)
      PROPOSE  (não existe — só então criar, definindo owner)
9. Registrar em CHANGELOG.md
10. Só então escrever código / SQL
```

## Estado resumido (seed 2026-07-09)

| Camada | Estado | Evidência |
| :--- | :--- | :--- |
| Tabelas | 330+ mapeadas por domínio | `tables/` (fichas por tabela) |
| SPs (Auth/Portal/Runtime) | auditadas | `DUMP-001-audit.md` |
| Runtime frontend | mapeado | `runtime/`, `callgraph/` |
| Relacionamentos SP↔tabela↔backend↔frontend | mapeados | `SP-TABLE-MAP.md`, `TABLE-SP-MAP.md`, `FRONT-SP-MAP.md`, `BACKEND-SP-MAP.md` |
| BLOQUEIO | `sp_auth_permissions_evaluate` ausente no dump | `DUMP-001-audit.md` R1 |

## Princípio

Não criar `dashboard`/`dashboard_widget` se já existe a família `painel_*`; não criar `usuario`
novo se já existe `usuario`/`perfil`/`permissao`/`sessao_usuario`. **Comprovar primeiro que nenhuma
combinação existente atende.** O dump é a fonte primária da verdade; o Knowledge Graph
(`SP-TABLE-MAP`, `TABLE-SP-MAP`, `FRONT-SP-MAP`, `BACKEND-SP-MAP`, `CALLGRAPH`) apenas reflete e
cruza essas relações para impedir duplicação semântica. Fluxo decisório e vinculante em
`DECISION-ENGINE.md` + `docs/canonical/MD-CANONICO-IA-007.md`. Respeitar `OWNERSHIP-MAP.md`,
`SYSTEM-INVARIANTS.md` e `ARCHITECTURE-TESTS.md`.
