# DECISION-ENGINE.md — O Cérebro da Engenharia

> Artefato vinculante (ver `MD-CANONICO-IA-007`). Não lista objetos — define o **fluxo decisório**
> determinístico que toda IA (Kilo / Gemini / ChatGPT / Claude / Copilot) executa antes de criar
> ou alterar qualquer objeto. Complementa `DATABASE-MAP.md` (índice) e `INVENTORY.md` (algoritmo).

## Princípio

A decisão de engenharia **não depende da memória ou do bom senso da IA**. Ela segue um fluxo
determinístico:

```text
DESCOBRIR → MEDIR IMPACTO → IDENTIFICAR O DONO → CLASSIFICAR → IMPLEMENTAR
```

Toda entrada passa pelo mesmo motor. O resultado é previsibilidade e ausência de deriva.

## Gates (checkpoints obrigatórios)

O motor é aplicado como **gates**: a IA não avança para o código sem ter passado por todos.
Isso garante que duas IAs sigam o mesmo caminho.

```text
GATE 1  Ler DATABASE-MAP.md
GATE 2  Ler DECISION-ENGINE.md (este)
GATE 3  Identificar o domínio (DOMAINS.md)
GATE 4  Executar Impact Analyzer (TABLE-SP-MAP → CALLGRAPH → BACKEND → FRONTEND → RUNTIME)
GATE 5  Encontrar Owner (OWNERSHIP-MAP.md)
GATE 6  Verificar Invariantes (SYSTEM-INVARIANTS.md)
GATE 7  Verificar duplicação (DUPLICATION-MAP.md)
GATE 8  Classificar (REUSE / ADAPT / EXTEND / MERGE / PROPOSE)
GATE 9  Só então escrever código
```

Falha em qualquer gate anterior bloqueia o avanço — não há "atalho" por boa intenção.

## Prompt obrigatório (o pipeline já impõe o fluxo)

O prompt da IA deve encadear os artefatos automaticamente, antes de qualquer código:

```text
TASK
  ↓ DATABASE-MAP        (índice navegável / verdade)
  ↓ OWNERSHIP-MAP       (quem é o dono da responsabilidade?)
  ↓ SP-TABLE-MAP        (quem usa quem)
  ↓ CALL-GRAPH          (cadeias reais)
  ↓ DECISION-ENGINE     (gates 1–9 + classificação)
  ↓ IMPLEMENTAÇÃO
```

Isso garante que duas IAs não concluam coisas diferentes por terem começado por lugares distintos.

## Fluxo decisório

```text
Entrada (requisito / funcionalidade / correção)
  ↓
Objeto solicitado (tabela? SP? runtime? frontend? contrato?)
  ↓
Knowledge Graph (DATABASE-MAP → *MAP → CALLGRAPH)
  ↓
Impact Analyzer (TABLE-SP-MAP → BACKEND → FRONTEND → RUNTIME)
  ↓
Existe no Dump/Código/Doc?
  ├── SIM ──────────────────────────────→ REUSE
  │                                        ↓
  │                              Não atende o requisito?
  │                                ├── SIM → ADAPT
  │                                │        ↓
  │                                │   Ainda insuficiente?
  │                                │     ├── SIM → EXTEND
  │                                │     │        ↓
  │                                │     │   Existe duplicação / pedaços espalhados?
  │                                │     │     ├── SIM → MERGE
  │                                │     │     └── NÃO → EXTEND aplicado
  │                                │     └── NÃO → ADAPT aplicado
  │                                └── NÃO → REUSE aplicado
  └── NÃO ──────────────────────────────→ PROPOSE
                                            ↓
                                    Consultar OWNERSHIP-MAP (quem é o dono?)
                                            ↓
                                    Validar SYSTEM-INVARIANTS (INV-001..)
                                            ↓
                                    Gerar SQL + registrar CHANGELOG + Impact Analyzer
```

## Saídas do motor

| Decisão | Significado | Ação |
|---|---|---|
| REUSE | já existe igual | usar objeto canônico (DB-ID) |
| ADAPT | existe sob outro nome/camada | adaptar mantendo compatibilidade |
| EXTEND | existe parcialmente | estender o objeto canônico |
| MERGE | comportamentos relacionados espalhados | consolidar num só dono |
| PROPOSE | não existe (após prova) | criar + SQL + Impact Analyzer + CHANGELOG |

Toda saída PROPOSE só é legítima após: (a) comprovar ausência por responsabilidade, (b) consultar
o dono da responsabilidade em `OWNERSHIP-MAP.md`, (c) confirmar que nenhuma `SYSTEM-INVARIANTS`
seria violada.

## Guardrails do motor

- O motor **nunca** parte do nome: parte da **responsabilidade** (§ busca em `MD-CANONICO-IA-007`).
- O motor **nunca** ignora o Impact Analyzer (alterações sem medição de impacto são proibidas).
- O motor **nunca** cria objeto sem dono: se não houver owner, o PROPOSE define um e o registra.
- O motor **sempre** valida invariantes antes de escrever código.

## Encadeamento com os outros artefatos

```text
DECISION-ENGINE.md (este — o cérebro)
  ↓ usa
DATABASE-MAP.md (índice) · INVENTORY.md (algoritmo)
  ↓ consulta
*MAP.md (arestas) · CALLGRAPH.md (cadeias) · OWNERSHIP-MAP.md (dono)
  ↓ respeita
SYSTEM-INVARIANTS.md (leis físicas) · ARCHITECTURE-TESTS.md (verificação)
  ↓ materializa
Dump SQL (Fonte da Verdade) → CHANGELOG.md
```
