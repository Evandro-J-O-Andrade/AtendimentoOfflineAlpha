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

1. `000-CONSTITUICAO-IA.md` (regras operacionais - este documento)
2. `docs/canonical/MD-CANONICO-IA-001-Lei-Evolucao-Documental.md` (lei de evolução documental)
3. `docs/canonical/MD-CANONICO-IA-002-Lei-Governanca-Arquitetural.md` (lei de governança arquitetural)
4. `docs/canonical/MD-110-Canonical-Laws.md` (leis supremas)
5. `docs/canonical/MD-100-Unified-Enterprise-Operating-System.md` (arquitetura)
6. `docs/canonical/MAP-001-Enterprise-Domain-Architecture.md` (domínios)
7. Documentos específicos do escopo

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