# MD-REGISTRY-002 — Runtime (Definição Canônica)

## Status
```text
CANÔNICO (ENGENHARIA)
CICLO 2.1 — Registry Canônico
Fase 3 — Etapa 2/5 (PRÉ-SQL: definição canônica)
Sequência obrigatória (Art. 74): MD → MAP → BR → Contratos → SQL
Este documento é a ETAPA MD. SQL só após MAP/BR e GATE.
Origem: engineering/REGISTRY-CANONICO-AUDITORIA.md (PROPOSE: runtime_registry)
```

---

## Definição Canônica de Runtime

```text
Runtime é a unidade responsável por RESOLVER, ORQUESTRAR e
EXECUTAR um conjunto de Capabilities dentro de um domínio,
expondo uma interface ÚNICA para consumidores humanos
(Web, Mobile, Kiosk, TV) e computacionais (APIs, MCP, Agentes de IA).
```

Corolários:

```text
- Runtime NÃO é uma IA. É o componente que conversa com IAs.
- Runtime NÃO conhece o Portal nem nenhum outro Runtime.
- Runtime descobre o alvo via Runtime Resolver (LEI 25).
- Runtime resolve internamente Master → Dispatcher → Executor → SP.
- Runtime é a única porta de entrada para executar Capabilities.
- Nenhum consumidor conhece Stored Procedures (LEI 25·26).
- Runtime NÃO implementa regra de negócio; COORDENA sua execução (LEI 26).
```

---

## Princípio da Neutralidade do Runtime

```text
O Runtime não contém regras de negócio específicas do domínio.

Sua responsabilidade limita-se a:
- resolver capacidades;
- validar contratos;
- validar contexto;
- resolver autorização;
- encaminhar para o pipeline canônico.

Toda regra de negócio permanece materializada nos Executors
e nas Stored Procedures canônicas.

Isso impede que, no futuro, lógica clínica/financeira migre
para o Runtime por conveniência.
```

---

## Runtime × Master × Executor

Três conceitos frequentemente confundidos:

```text
Runtime   → RESOLVE.   Recebo uma Capability; descubro quem executa.
Master    → ORQUESTRA.  Recebo a operação; decido o fluxo.
Executor  → EXECUTA.   Realizo a operação (chama a SP).
```

```text
Capability
   ↓
Runtime   (resolve + valida + encaminha)
   ↓
Master    (orquestra o fluxo)
   ↓
Dispatcher
   ↓
Executor  (executa)
   ↓
Stored Procedure
   ↓
Resultado
   ↓
Evento
   ↓
Auditoria
   ↓
Runtime   (coordena a resposta; NÃO assume a regra)
   ↓
Cliente
```

O retorno evidencia que o Runtime também coordena a resposta e o
fechamento da operação, sem assumir a regra de negócio.

---

## Responsabilidades do Runtime

```text
1. Capability Resolver   — descobre o que existe (via Capability Registry)
2. Runtime Resolver      — descobre qual Runtime atende (LEI 25)
3. Authorization Bridge  — delega permissão ao Guardião (sp_auth_permissions_evaluate)
4. Execution Dispatch    — chama Master → Dispatcher → Executor → SP
5. Contract Validation   — valida payload contra contrato canônico
6. Audit & Events        — emite evento e audita (kernel_ledger)
```

---

## Catálogo de Runtimes (a ser materializado em runtime_registry)

```text
Portal Runtime
Auth Runtime
Context Runtime
Notification Runtime
Workflow Runtime
Integration Runtime
Estoque Runtime
Farmácia Runtime
Financeiro Runtime
Laboratório Runtime
AI Runtime
```

O Runtime possui **Atributos** (propriedades próprias, armazenadas)
e **Relações** (descobertas pelo metamodelo / Knowledge Graph).
O Runtime é **nó de grafo**, não repositório de listas.

### Atributos do Runtime (armazenados no runtime_registry)

```text
codigo
nome
dominio
descricao
versao
status
responsavel
tipo_consumidor   (HUMANO | COMPUTACIONAL | AMBOS)
runtime_type      (Core | Platform | Domain | Infrastructure | Integration)
endpoint_pattern  (FAMÍLIA de endpoints, ex: /auth/*, /portal/* — ver abaixo)
observacoes
```

### endpoint_pattern é FAMÍLIA, não endpoint concreto

```text
✅ /auth/*
✅ /portal/*
❌ /auth/login   (endpoint concreto pertence ao API Registry)
```

### Runtime Type (classificação)

```text
Core            → Auth Runtime
Platform        → Portal Runtime
Domain          → Farmácia, Estoque, Financeiro, Laboratório Runtime
Infrastructure  → Infrastructure Runtime
Integration      → AI Runtime, Integration Runtime
```

### Relações do Runtime (grafo — NÃO armazenadas no Runtime)

```text
Runtime ── expõe ────────▶ Capability
Runtime ── orquestra ─────▶ Master
Runtime ── valida ────────▶ Contrato
Runtime ── emite ─────────▶ Evento
Runtime ── depende de ────▶ Runtime (dependências)
```

Essas relações são navegáveis pelo metamodelo e pelo Knowledge Graph.
Isso evita duplicar listas entre registries — princípio:
**uma responsabilidade, uma fonte de verdade** (Art. 72).

---

## Relacionamento com Capability Registry (Etapa 1)

```text
Runtime 1 ── expõe ── N Capabilities

Capability ↔ Runtime: em revisão (BR-CAP-010).
Se uma Capability for consumida por múltiplos Runtimes
(Portal, AI, API, Mobile), adota-se associação N:N
(capability_runtime) — definido quando runtime_registry
for materializado (Etapa 2, fase SQL).
```

---

## GATE-PLATFORM-001 (pré-validação da Etapa 2)

```text
Arquitetura : ✅ respeita Constituição
              ✅ não viola LEI 23–26
              ✅ não altera Kernel (cria registry, não muda core)
              ✅ não cria fluxo paralelo
Banco Vivo  : ✅ auditado (runtime_* existem como infra;
              falta registry lógico de descoberta)
Engenharia  : ✅ MD (este)  ⏳ MAP  ⏳ BR  ⏳ Contratos  ⏳ SQL
```

---

## Próximo passo (Etapa 2)

```text
1. ✅ MD-REGISTRY-002 (definição canônica de Runtime)
2. → MAP-REGISTRY-002 (estrutura de runtime_registry)
3. → BR-REGISTRY-002 (regras de Runtime/Registry)
4. → Contratos + API de descoberta
5. → SQL: CREATE runtime_registry (+ capability_runtime se N:N)
6. → GATE final
```
