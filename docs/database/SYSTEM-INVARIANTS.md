# SYSTEM-INVARIANTS.md — Leis Físicas do Sistema

> Invariantes são propriedades que **sempre** devem ser verdadeiras. Toda IA (Kilo / Gemini /
> ChatGPT / Claude / Copilot) verifica este documento antes de implementar: se a mudança violar
> algum invariante, ela é **proibida** até ser justificada e aprovada. Vinculante
> (ver `MD-CANONICO-IA-007`). Verificáveis por `ARCHITECTURE-TESTS.md`.

## INV-001 — Sessão obrigatória

> Nenhuma SP crítica executa sem sessão válida.

- Proíbe: SP de negócio sem validação de `sessao_usuario`.
- Camada: Guardião.
- Verificação: `AT-002`.

## INV-002 — Toda gravação é auditada

> Toda escrita de dados passa por auditoria (`auditoria_evento` / `log_auditoria`).

- Proíbe: `INSERT/UPDATE/DELETE` sem aresta de auditoria no `SP-TABLE-MAP`.
- Camada: Auditoria.
- Verificação: `AT-002`.

## INV-003 — Runtime nasce de sessão

> Todo runtime nasce de uma sessão válida.

- Proíbe: runtime (`runtime_*`, `kernel_*`) sem vínculo de contexto/sessão.
- Camada: Runtime / Guardião.
- Verificação: `AT-001` (indireto).

## INV-004 — Permissão só no Permission Engine

> Nenhuma permissão é avaliada fora do Permission Engine.

- Proíbe: checagem de permissão inline em SP/backend fora de `sp_auth_permissions_evaluate`.
- Camada: Permission.
- Verificação: `AT-003`.

## INV-005 — Frontend não chama SQL direto

> Nenhum frontend chama SQL diretamente.

- Proíbe: SQL embutido em apps frontend.
- Camada: Frontend → API.
- Verificação: `AT-001`.

## INV-006 — Sem fetch() direto no React

> Nenhum componente React usa `fetch()` direto.

- Proíbe: `fetch()` fora de `packages/api`.
- Camada: Frontend.
- Verificação: `AT-001`.

## INV-007 — Widget nasce de WidgetContract

> Todo widget nasce de `WidgetContract`.

- Proíbe: widget sem contrato canônico.
- Camada: Frontend.
- Verificação: `AT-004`.

## Processo de violação

```text
Implementação proposta
  ↓
Validar SYSTEM-INVARIANTS
  ↓
Viola algum?
  ├── NÃO → seguir
  └── SIM → proibido, a menos que:
              • haja justificativa técnica documentada
              • seja aprovado por governança (MD-CANONICO-IA-002)
              • o invariante seja formalmente revisado (nova versão deste doc)
```

Novos invariantes entram aqui com ID sequencial (`INV-008`, ...) e referência cruzada em
`ARCHITECTURE-TESTS.md`.
