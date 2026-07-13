# GATE-PLATFORM-001 — Fundação Congelada

## Status
```text
CANÔNICO
OBRIGATÓRIO
VINCULADO AO CONGELAMENTO DO CICLO ARQUITETURAL 1
(000-CONSTITUICAO-PLATAFORMA.md — Título XV, Art. 68)
```

---

## Objetivo

Garantir que nenhum novo domínio (Portal, Farmácia, Financeiro,
RH, Estoque, ...) reintroduza arquitetura paralela ou altere a
fundação congelada (LEI 23–26, Runtime, Kernel, MAP-019, MD-110).

Este gate é a porta de entrada obrigatória da fase de
**engenharia sobre a plataforma**.

---

## Gatilho

```text
ANTES de iniciar qualquer novo domínio ou capability:
  → GATE-PLATFORM-001 DEVE ser validado e aprovado.
```

---

## Checklist de Aprovação

### Arquitetura
- [ ] Respeita a Constituição (000-CONSTITUICAO-PLATAFORMA.md)
- [ ] Não viola LEI 23–26
- [ ] Não altera Runtime
- [ ] Não altera Kernel
- [ ] Não cria fluxo paralelo

### Banco Vivo
- [ ] Dump analisado
- [ ] Knowledge Graph consultado
- [ ] REUSE tentado
- [ ] ADAPT tentado
- [ ] EXTEND avaliado
- [ ] MERGE avaliado
- [ ] Somente então PROPOSE

### Engenharia
- [ ] MD criado
- [ ] MAP criado
- [ ] BR criada
- [ ] FRONT atualizado
- [ ] Contratos definidos
- [ ] APIs definidas
- [ ] Runtime definido

### Materialização
- [ ] Master
- [ ] Dispatcher
- [ ] Executors
- [ ] Procedures
- [ ] Auditoria
- [ ] Eventos

### IA
- [ ] Capability Registry
- [ ] Tool Registry
- [ ] Runtime Registry
- [ ] AI Runtime compatível
- [ ] MCP compatível

---

## Critério de Falha

```text
Se qualquer item de Arquitetura falhar:
  → DOMÍNIO BLOQUEADO.
  → Não inicia implementação.
  → Retorna para revisão arquitetural (ADR + Arquiteto Chefe).
```

Itens de Banco Vivo/Engenharia/Materialização/IA podem ser
completados incrementalmente APÓS o domínio ser aprovado,
desde que a fundação não seja violada.

---

## Precedência de Leitura (para IAs)

Antes de qualquer trabalho no domínio, a IA segue:

```text
Constituição
   ↓
Leis
   ↓
ADRs
   ↓
Banco Vivo
   ↓
Knowledge Graph
   ↓
MDs
   ↓
MAPs
   ↓
BRs
   ↓
FRONTs
   ↓
Código
```

Varíação coerente (Banco Vivo como fonte primária de dados):

```text
Constituição → Leis → ADRs → Banco Vivo → Knowledge Graph
   → MDs → MAPs → BRs → FRONTs → Código
```

Constituição é o documento de MÁXIMA precedência para toda IA.

---

## GATE Intermediário de Discovery (pré-SQL)

Antes de gerar SQL de Discovery (MD-REGISTRY-003), três validações:

```text
CONTRATO       : definição de entrada e saída existe?
RASTREABILIDADE: a resposta navega
                 Capability → Runtime → Master → Executor → SP?
SEGURANÇA      : respeita tenant / contexto / permissão / consumidor?
                 (IA, Mobile e Portal NÃO enxergam o mesmo grafo)
```

Falha → retorna a ADR + Arquiteto Chefe. Só após aprovação
destrava SQL, API Discovery e Runtime Discovery.

---

## Testes Finais de Registry (Etapa 2+)

Ao materializar qualquer registry (API, Tool, Event, Domain...),
três testes obrigatórios antes da aprovação final (MD-REGISTRY-000):

```text
CONSISTÊNCIA : para toda Capability, PRIMARY == 1.
               PRIMARY = 2 é falha (resolução ambígua).

NAVEGAÇÃO    : dada qualquer Capability, o sistema descobre
               automaticamente, sem configuração manual:
                 Capability → Runtime → Master → Executor
                 → SP → Evento → Auditoria.
               Se passar, o metamodelo governa a plataforma.

INTEGRIDADE  : para cada Runtime PRIMARY, o sistema prova
               automaticamente a cadeia materializada:
                 Runtime → Master → Dispatcher → Executor → SP.
               Elo faltante → FAIL (Capability não pode estar
               "registrada" sem execução materializada).
```

Falha em qualquer um → domínio retorna a ADR + Arquiteto Chefe.

---

## Assinatura

| Papel | Responsabilidade |
|-------|------------------|
| Arquiteto Chefe | Aprovação final do gate |
| Líder de Domínio | Valida checklist do domínio |
| IA | Segue ordem de leitura e respeita fundação |
| Auditoria | Valida conformidade contínua |

---

Documento Canônico de Gate — GATE-PLATFORM-001

**Fecha definitivamente o Ciclo Arquitetural 1.**
