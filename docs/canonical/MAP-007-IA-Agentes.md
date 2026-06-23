# MAP-007 — Mapa de IA & Agentes

## Status

Documento Canônico De Mapeamento.
Fonte: dump + estrutura legada + MDs cognitivos (081-090).

---

## Componentes Identificados

| Componente | Fonte | Status |
|------------|-------|--------|
| IA Canônica | docs/canonical/IA_CANONICA.md | TEORIA |
| AI Orchestration | MD-009, MD-027, MD-052 | CANONICO |
| Enterprise Agent Platform | MD-057 | CANONICO |
| Hyperautomation Platform | MD-056 | CANONICO |
| AI Copilot Framework | MD-081 | CANONICO |
| Agent Marketplace | MD-082 | CANONICO |
| Prompt Governance | MD-083 | CANONICO |
| AI Data Fabric | MD-052 | CANONICO |
| Knowledge Graph | MD-054, MD-084 | CANONICO |
| Data Lakehouse | MD-051, MD-085 | CANONICO |

---

## Mapeamento Técnico (Dump + Legado)

| Mecanismo | Tipo | Observação |
|-----------|------|------------|
| ia_canônica | Documento conceitual | Fonte: IA_CANONICA.md |
| N8N canônico | Motor de automação | docs/canonical/N8N_CANONICO.md |
| Modelos IA | Integração Azure/OpenAI | Ver MD-027, MD-057 |
| Agentes IA | Arquitetura de agentes | Ver MD-057, MD-082 |
| Copilots por app | Extensão de app | Ver MD-081 |

---

## Observações

- IA no legado está em estágio conceitual (IA_CANONICA.md).
- Nenhuma tabela específica de IA identificada no dump atual.
- Integração com provedores externos (Azure OpenAI) documentada em MDs.
- Hyperautomation e Agent Platform aguardam implementação faseada.

---

## Próximos Passos

1. Consolidar contratos de dados para IA (MD-052).
2. Definir catálogo de modelos por tenant.
3. Criar tabelas de auditoria de IA (prompts, respostas, tokens).
4. Implementar Agent Runtime (MD-057).
