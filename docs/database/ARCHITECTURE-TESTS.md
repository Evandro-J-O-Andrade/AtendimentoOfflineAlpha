# ARCHITECTURE-TESTS.md — Verificação das Leis

> Documenta **como verificar** as leis e invariantes do sistema. Hoje manual/estática; no futuro
> automatizável em CI. Vinculante (ver `MD-CANONICO-IA-007`). Cada `AT` referencia o invariante
> (`SYSTEM-INVARIANTS.md`) que comprova.

## Estado

| ID | Verificação | Invariante | Estado atual |
|---|---|---|---|
| AT-001 | Existe `fetch()` fora de `packages/api`? | INV-006 | PENDENTE (varredura) |
| AT-002 | Existe SP crítica sem auditoria? | INV-001, INV-002 | PENDENTE (varredura) |
| AT-003 | Existe tabela duplicando domínio existente? | INV-004 (e DUPLICATION-MAP) | PENDENTE (varredura) |
| AT-004 | Existe widget sem `WidgetContract`? | INV-007 | PENDENTE (varredura) |

## Casos

### AT-001 — Acesso de rede no frontend

```text
Alvo: apps/**, packages/**
Procurar: fetch( | axios( | new XMLHttpRequest
Exceção permitida: packages/api
Resultado esperado: 0 ocorrências fora de packages/api
Violação → INV-005 / INV-006
```

### AT-002 — Auditoria em SP crítica

```text
Alvo: procedures/ (SPs de escrita)
Para cada SP de gravação, checar aresta de auditoria em SP-TABLE-MAP.md
Resultado esperado: toda SP de gravação tem auditoria_evento / log_auditoria
Violação → INV-001 / INV-002
```

### AT-003 — Duplicação de domínio

```text
Alvo: tables/ + DUPLICATION-MAP.md
Para cada nova tabela proposta, buscar equivalente por responsabilidade
Resultado esperado: 0 duplicações sem MERGE/ADAPT documentado
Violação → INV-004 (e regra de não-duplicação)
```

### AT-004 — WidgetContract

```text
Alvo: componentes de widget no frontend
Para cada widget, checar herança/contrato WidgetContract
Resultado esperado: todo widget deriva de WidgetContract
Violação → INV-007
```

## Automação futura (recomendada)

- `AT-001/006`: regra de lint (`no-restricted-globals: [fetch, XMLHttpRequest]` fora de `packages/api`).
- `AT-002`: script que cruza `procedures_raw_texts/` com `SP-TABLE-MAP.md`.
- `AT-003`: script que cruza `tables_raw/` com `DUPLICATION-MAP.md`.
- `AT-004`: regra de tipo/config que exige `extends WidgetContract`.

Toda falha de `AT` bloqueia a entrega até ser resolvida ou formalmente isenta por governança.

## Automação da Governança (próximo ganho)

A documentação atingiu cobertura suficiente; o retorno agora vem de **aplicar essas regras
automaticamente**, não de ampliá-las. Sugestões de automação (scripts já existem em
`docs/database/`: `checklist_integridade.ps1`, `generate_tables_docs.ps1`):

```text
CI (pre-merge):
  • AT-001/006 → lint (no-restricted-globals: fetch/XMLHttpRequest fora de packages/api)
  • AT-002     → script que cruza procedures_raw_texts/ com SP-TABLE-MAP.md
  • AT-003     → script que cruza tables_raw/ com DUPLICATION-MAP.md
  • AT-004     → regra de tipo que exige extends WidgetContract
  • Gate extra → script que exige entrada em DECISION-LOG.md para todo PROPOSE/MERGE

Prompt padronizado das IAs (gates de DECISION-ENGINE.md):
  DATABASE-MAP → DECISION-ENGINE → domínio → Impact Analyzer → Owner → Invariantes → duplicação → classificar
```

O objetivo é que o processo de governança seja **imposto pelo pipeline**, não lembrado pela IA.
