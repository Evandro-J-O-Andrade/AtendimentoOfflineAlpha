# MAP-005 — Eventos

## Status

Documento Canônico De Mapeamento.
Fonte: Dump20260606.sql.

---

## Mecanismos Identificados

| Mecanismo | Tipo | Observação |
|-----------|------|------------|
| auditoria_evento | Ledger canônico de auditoria | Referência oficial no dump |
| atendimento_evento | Evento de domínio HIS/OPERACIONAL | Presente no dump |
| evento_ffa | Evento de fluxo assistencial | Presente no dump |
| fila_evento / fila_operacional_evento | Eventos de operação de fila | Presente no dump |
| workflow_ffa_evento | Workflow de evento | Presente no dump |
| eventos_fluxo | Motor de fluxo genérico | Presente no dump |
| faturamento_evento | Evento financeiro | Presente no dump |
| kernel_ledger | Ledger global da plataforma | Presente no dump |
| ledgers de sincronização | Reconciliacao / sync | Presente no dump |
| estoque_ledger | Ledger de estoque | Presente no dump |
| venda_evento / caixa_evento | Eventos PDV | Presente no dump |
| chamado_evento / cat_evento | Eventos SAC/CAT | Presente no dump |
| obito_evento | Evento de óbito | Presente no dump |

## Observações

- Existem múltiplos motores de evento coexistindo.
- Convergência canônica deve definir qual é o Event Store oficial (ex: `kernel_ledger` como global e `auditoria_evento` como imutável).
