# MAP-008 — Mapa de Workflows & Automação

## Status

Documento Canônico De Mapeamento.
Fonte: dump + estrutura legada + MDs de automação.

---

## Componentes Identificados

| Componente | Fonte | Status |
|------------|-------|--------|
| Workflow Canônico | docs/canonical/WORKFLOW_CANONICO.md | TEORIA |
| Workflow Engine | fluxo_*, workflow_*, eventos_fluxo no dump | PARCIAL |
| Hyperautomation Platform | MD-056 | CANONICO |
| N8N Canônico | docs/canonical/N8N_CANONICO.md | TEORIA |
| Workflow Fabric (N8N Enterprise) | MD-089 | CANONICO |
| Event Store Core | MD-005, MD-025 | CANONICO |

---

## Mapeamento Técnico (Dump + Legado)

| Mecanismo | Tipo | Observação |
|-----------|------|------------|
| fluxo_* | Tabelas de workflow | Presente no dump |
| workflow_* | Engine de workflow | Presente no dump |
| eventos_fluxo | Motor de eventos de fluxo | Presente no dump |
| fila_evento / fila_operacional_evento | Eventos de fila | Presente no dump |
| N8N self-hosted | Arquitetura proposta | N8N_CANONICO.md |

---

## Observações

- Múltiplos motores de workflow coexistindo no legado (fluxo_*, workflow_*).
- N8N proposto como camanda unificada (MD-089).
- Event Store canônico (kernel_ledger) deve ser fonte única de eventos.
- Falta mapear todas as SPs de workflow no dump.

---

## Próximos Passos

1. Migrar workflows legados para N8N Enterprise.
2. Unificar eventos em kernel_ledger.
3. Documentar SPs de workflow existentes.
4. Criar catálogo de workflows canônicos por domínio.
