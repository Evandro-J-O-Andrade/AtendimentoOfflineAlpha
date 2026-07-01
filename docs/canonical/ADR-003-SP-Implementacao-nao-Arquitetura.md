# ADR-003 — Stored Procedures como Implementação, não Arquitetura

## Status
ACEITO

## Contexto

No banco legado, as Stored Procedures são o núcleo da lógica.

Elas concentram centenas de regras de negócio.

Há uma tendência natural de tratá-las como arquitetura.

Isso é um erro porque:

- SPs são implementações concretas de responsabilidades;
- elas refletem a arquitetura do legado, não a arquitetura alvo;
- podem e devem ser substituídas sem alterar a arquitetura.

## Decisão

```text
Nenhuma Stored Procedure representa arquitetura.
Ela representa apenas uma implementação.
```

A arquitetura extrai:

- responsabilidade (o que faz)
- contrato (entradas e saídas)
- eventos (o que registra)
- dependências (o que chama)
- papel arquitetural (Dispatcher, Orquestrador, Executor, Ledger)

E reconstrói no padrão Enterprise.

## Consequências

- Nenhuma SP é migrada literalmente para o Core.
- Nenhuma SP define decisão arquitetural.
- MDs e MAPs descrevem arquitetura, não implementação.
- SPs são implementadas conforme a arquitetura documentada.
- Legado é fonte de evidência, não de arquitetura.

## Alternativas Consideradas

```text
ALTERNATIVA A: Migrar SPs existentes para o Core
  → Rejeitada. Copiaria arquitetura legada.

ALTERNATIVA B: Reescrever todas as SPs primeiro
  → Rejeitada. Arquitetura deve existir antes da implementação.

ALTERNATIVA C: Extrair papel arquitetural e reconstruir
  → Aceita. Implementada como padrão oficial.
```

## Relacionamentos

- MD-CANONICO-IA-003 (Lei da Evolução do Core)
- LC-DB-001 (SP como Porta Oficial)
- LC-DB-003 (Eventos vs Triggers)
- MD-003 (Dispatcher)
- MD-CANONICO-IA-002 (Engenharia Reversa)

---

ADR-003 — Stored Procedures como Implementação, não Arquitetura

**Aceito em 2026-06-29.**
