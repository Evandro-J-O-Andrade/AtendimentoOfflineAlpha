# MD-REGISTRY-001 — Capability Registry (EXTEND de `permissao`)

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Fase 3 — Materialização (etapa 1 de 5)
Origem: engineering/REGISTRY-CANONICO-AUDITORIA.md (Fase 2: EXTEND/MERGE)
```

---

## Objetivo

Elevar `permissao` de "tabela de autorização" a embrião do
**Capability Registry**, sem criar nova tabela (REUSE/ADAPT).

---

## Decisão da Auditoria (Banco Vivo)

`permissao` (Dump20260618.sql, L11733) já relaciona:

```text
Procedure        → nome_procedure
Frontend Action  → acao_frontend
Metadata         → metadata (json)
Menu/UI          → grupo_menu, icone, ordem_menu, visivel_menu
Domínio          → dominio
```

Ou seja, ela já contém parte do grafo de execução:

```text
Capability
   ↓
Authorization (permissao)
   ↓
Execution (nome_procedure → SP)
```

Portanto **não se cria `capability_registry`**. Faz-se EXTEND de
`permissao`. Isso evitou uma tabela desnecessária (ganho do Banco Vivo).

---

## Tipo de Capability (coluna lógica → física)

```text
tipo_capability ∈ { OPERACAO, CONSULTA, EVENTO, INTEGRACAO, SISTEMA, IA }
```

Permite que um agente pergunte:
- "Liste capabilities operacionais."
- "Liste apenas capabilities consumíveis por IA."

sem interpretar nomes de procedures.

---

## Relacionamentos (resolvidos pelo Runtime, não pelo cliente)

```text
Capability → Authorization  (permissao atual)
Capability → Execution      (nome_procedure → SP)
Capability → Runtime        (id_runtime  — etapa 2)
Capability → Tool           (id_tool     — etapa 3)
Capability → Contract       (id_contrato — ADAPT de contrato)
Capability → API            (api_registry — etapa 4)
Capability → Event          (event_registry — etapa 5)
```

As colunas `id_runtime` e `id_tool` entram NULL agora e são
"cabeadas" quando seus registries forem materializados (trilha
única em ordem de dependência).

---

## Revisão de Cardinalidade (reserva de aprovação)

```text
Etapa 1 APROVADA com ressalva arquitetural.

id_runtime / id_tool entram NULL (sem FK). Não se assume 1:1.
Pode evoluir para N:N via tabela de associação
(capability_runtime / capability_tool) se uma Capability for
exposta por múltiplos Runtimes/Tools. Decisão pendente de ADR.
Ver BR-CAP-010.
```

---

## GATE-PLATFORM-001 (validação desta etapa)

```text
Arquitetura : ✅ respeita Constituição
              ✅ não viola LEI 23–26
              ✅ não altera Runtime/Kernel
              ✅ não cria fluxo paralelo
Banco Vivo  : ✅ auditado (REGISTRY-CANONICO-AUDITORIA.md)
              ✅ REUSE/ADAPT aplicados (permissao)
Engenharia  : ✅ MD  ✅ MAP  ✅ BR  ✅ Contratos
```
