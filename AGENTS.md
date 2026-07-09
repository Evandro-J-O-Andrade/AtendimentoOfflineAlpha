# AGENTS.md - Guia para IAs Colaboradoras

## SYSTEM PROMPT Fundamental

**Leia primeiro antes de qualquer tarefa:** `000-CONSTITUICAO-IA.md`

Este documento estabelece as regras de conduta operacional para todas as IAs que atuam no projeto AtendimentoOfflineAlpha.

---

## Estrutura de Documentos Canônicos

- **MD-*.md** — Documentos Canônicos (fundamento da plataforma)
- **MAP-*.md** — Mapas de Arquitetura (domínios, integrações, fluxos)
- **BR-*.md** — Business Rules (regras de negócio específicas)
- **FRONT-*.md** — Documentos de Experiência Frontend

---

## Ordem de Leitura Obrigatória

1. `000-CONSTITUICAO-PLATAFORMA.md` (Constituição Suprema da Plataforma)
2. `000-CONSTITUICAO-IA.md` (Guia Operacional das IAs)
3. `docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md` (Lei de Evolução Documental)
4. `docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md` (Lei de Governança Arquitetural)
5. `docs/canonical/MD-CANONICO-IA-003-Lei-Evolucao-Core.md` (Lei da Evolução do Core)
6. `docs/canonical/MD-CANONICO-IA-004-Matriz-Evolucao-Projeto.md` (Matriz de Evolução)
7. `docs/canonical/MD-110-Canonical-Laws.md` (Leis Supremas)
8. `docs/canonical/MD-100-Unified-Enterprise-Operating-System.md` (Arquitetura)
9. `docs/canonical/MAP-001-Enterprise-Domain-Architecture.md` (Domínios)
10. Documentos específicos do escopo

---

## Comandos Úteis

```bash
# Explorar estrutura
Get-ChildItem -Recurse -Filter "*.md"

# Buscar padrões
Select-String -Pattern "padrão" -Path "*.md" -Recurse

# Listar tabelas
Get-ChildItem docs/database/tables/
```

---

## Classificação de Domínios

CORE | IAM | PORTAL | WORKFLOW | KERNEL | SOCIAL | CHAT | WIKI | ANALYTICS | APP

Detalhes em `000-CONSTITUICAO-IA.md`.