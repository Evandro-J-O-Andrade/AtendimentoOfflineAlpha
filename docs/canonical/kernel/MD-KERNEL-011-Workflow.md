# MD-KERNEL-011 — Workflow

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Integration Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-009 — Runtime
Consumido por: MD-KERNEL-012 — Event
Consumido por: MD-KERNEL-013 — Ledger
Consumido por: MD-KERNEL-014 — Integration
```

---

## 1. Objetivo

Definir o conceito canônico de **Workflow** no Kernel Enterprise.

Workflow é a camada responsável por responder:

> **"Qual é o estado atual de um processo e qual transição pode ocorrer?"**

Ele não é uma regra de negócio.
Ele não é um módulo operacional.
Ele é o **coordenador de estados e transições de processos** do Kernel, garantindo que processos complexos sigam fluxos definidos sem incorporar regras específicas de domínio.

Sem Workflow, processos complexos não têm coordenação.
Sem Runtime, Workflow não tem como executar transições.

---

## 2. Definição Canônica

```text
Workflow representa o mecanismo de coordenação
de estados e transições de processos na plataforma
New Wave Enterprise.

Workflow é:
  - um coordenador de processos
  - um gerenciador de estados
  - um validador de transições
  - um orquestrador de etapas
  - independente de regra de negócio
  - independente de produto
  - um produtor de eventos

Workflow não responde:
  "qual é a regra clínica/fiscal/financeira?"
  "como executar a operação?"
  "quem pode acessar?"

Workflow responde:
  "qual é o estado atual
   e qual transição é válida
   neste momento?"
```

### 2.1 Princípio fundamental

```text
Workflow coordena estados.
Workflow não define regras de negócio.
Workflow não executa operações.
Workflow apenas garante que processos
sigam fluxos válidos dentro do Kernel.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Coordenador | Gerencia estados e transições de processos |
| Stateful | Mantém estado corrente de cada processo |
| Transicional | Valida e aplica transições entre estados |
| Orquestrador | Coordena múltiplas etapas de forma sequencial ou paralela |
| Independente | Não depende de regra de negócio específica |
| Produtor de eventos | Toda transição relevante gera evento no Ledger |
| Auditável | Toda mudança de estado é registrada |
| Compensável | Suporta compensação e rollback de transições |

### 2.3 Tipos de Workflow

| Tipo | Natureza | Observação |
|------|----------|------------|
| Linear | Sequência fixa de etapas | Ex: onboarding de usuário |
| Condicional | Transições baseadas em condições | Ex: triagem de paciente |
| Paralelo | Múltiplas etapas simultâneas | Ex: faturamento + estoque |
| Aprovativo | Requer aprovação humana | Ex: cancelamento de atendimento |
| Temporal | Triggerado por tempo | Ex: expiração de sessão |
| Event-driven | Triggerado por eventos | Ex: sync após falha de conexão |
| Compensável | Suporta rollback | Ex: transação financeira |

---

## 3. Boundaries

### 3.1 Workflow É

- O coordenador de estados e transições de processos.
- O gerenciador de ciclo de vida de fluxos complexos.
- O validador de transições entre estados.
- O orquestrador de etapas sequenciais, paralelas e condicionais.
- O produtor de eventos de mudança de estado.
- O mecanismo de compensação e rollback.
- A camada que conecta Runtime, Event e Ledger.

### 3.2 Workflow NÃO é

- ❌ **Regra de negócio**: não define como cadastrar paciente, faturar ou dispensar.
- ❌ **Runtime**: não executa operações técnicas.
- ❌ **Event**: não comunica fatos; produz eventos.
- ❌ **Ledger**: não registra histórico; produz eventos para o Ledger.
- ❌ **Permissão**: não decide acesso.
- ❌ **Menu**: não projeta navegação.
- ❌ **Interface**: não exibe telas.
- ❌ **Produto**: não é HIS, ERP, CRM ou aplicação final.

### 3.3 Limites claros

```text
WORKFLOW
  │
  ├── É responsável por: estados, transições, orquestração, ciclo de vida
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── catálogo estrutural (Registry)
        ├── descoberta contextual (Discovery)
        ├── capacidade funcional (Capability)
        ├── execução técnica (Runtime)
        ├── projeção de interface (Navigation)
        ├── comunicação de eventos (Event)
        ├── registro histórico (Ledger)
        └── regra de negócio (Domínio consumidor)
```

---

## 4. Responsabilidades

4.1 Manter o estado corrente de cada processo.
4.2 Definir e validar transições entre estados.
4.3 Orquestrar etapas de forma sequencial, paralela ou condicional.
4.4 Gerenciar ciclo de vida de processos complexos.
4.5 Suportar aprovações humanas e automáticas.
4.6 Produzir eventos de mudança de estado para o Ledger.
4.7 Suportar compensação e rollback de transições.
4.8 Garantir que nenhuma transição inválida ocorra.
4.9 Manter histórico de transições para auditoria.
4.10 Suportar múltiplos processos simultâneos por tenant.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Workflow Runtime | Executa e coordena workflows |
| Administração da Plataforma | Define workflows estruturais |
| Desenvolvedor de Produto | Define workflows de domínio |
| IA | Sugere otimizações de fluxo (não decide) |
| Automação | Triggera workflows por eventos |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Runtime | Consulta Workflow para validar transições |
| Event | Consome eventos de mudança de estado de Workflow |
| Ledger | Persiste eventos de Workflow |
| Integration | Consome Workflow para integrações externas |
| Navigation | Projeta estado de Workflow para usuário |
| Portal | Apresenta workflows ao usuário |
| IA | Consulta Workflow para sugerir ações no contexto correto |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Workflow
  │
  ├── Process (processo)
  │     └── 1:N → State (estados)
  │           └── 1:N → Transition (transições)
  │
  ├── Runtime (execução)
  │
  ├── Authorization (permissão)
  │
  ├── 1:N → Event (eventos de mudança)
  │
  ├── 1:N → Ledger (registro histórico)
  │
  └── 1:N → Integration (exposição externa)
```

### 7.2 Modelo conceitual

```text
Workflow: Atendimento Paciente
  │
  ├── State: CRIADO
  │     └── Transition: INICIAR_ATENDIMENTO
  │
  ├── State: EM_ANALISE
  │     └── Transition: APROVAR / REPROVAR / CANCELAR
  │
  ├── State: APROVADO
  │     └── Transition: EXECUTAR / SUSPENDER
  │
  ├── State: EXECUTADO
  │     └── Transition: FINALIZAR / REABRIR
  │
  └── State: FINALIZADO
        └── Transition: REABRIR (condicional)
```

### 7.3 Workflow e regra de negócio

```text
WORKFLOW
  │
  ├── Define: "Atendimento pode ir de CRIADO para EM_ANALISE"
  │
  ├── NÃO define: "O que significa estar em análise"
  │
  ├── NÃO define: "Quais dados cadastrar na análise"
  │
  ├── NÃO define: "Qual médico pode aprovar"
  │
  └── NÃO define: "O que acontece após aprovação"
        └── Isso é regra de negócio do domínio consumidor
```

### 7.4 Separação de conceitos

```text
WORKFLOW
  │
  ├── NÃO é Regra de Negócio
  │     └── Regra de negócio mora no domínio consumidor
  │
  ├── NÃO é Runtime
  │     └── Runtime executa; Workflow coordena
  │
  ├── NÃO é Event
  │     └── Event comunica; Workflow produz eventos
  │
  ├── NÃO é Ledger
  │     └── Ledger registra; Workflow alimenta Ledger
  │
  ├── NÃO é Permissão
  │     └── Permissão é decidida por Authorization
  │
  └── NÃO é Menu
        └── Menu é projetado por Navigation
```

### 7.5 Workflow e compensação

```text
Workflow suporta transições compensatórias:

Execução
   ↓
Falha detectada
   ↓
COMPENSAR
   ↓
Estado anterior restaurado
   ↓
Evento de compensação registrado no Ledger
```

Isso garante resiliência em operações distribuídas.

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Runtime | Workflow executa transições via Runtime |
| Authorization | Workflow valida permissão para transições |
| Identity | Workflow rastreia identidade que solicitou transição |
| Tenant | Workflow opera dentro de um Tenant |
| Session | Workflow valida sessão ativa |
| Context | Workflow aplica contexto operacional |

### 8.2 É dependido por

| Domínio | Como depende de Workflow |
|---------|---------------------------|
| Event | Event registra mudanças de estado de Workflow |
| Ledger | Ledger persiste eventos de Workflow |
| Integration | Integration consome Workflow para integrações |
| Navigation | Navigation projeta estado de Workflow |
| Runtime | Runtime executa passos de Workflow |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability | Runtime | Navigation | Workflow | Event | Ledger | Integration |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- | ---------- | ------- | ---------- | -------- | ----- | ------ | ------------ |
| Identity     | —        |        |         |         |               |           |          |            |         |            |          |       |        |              |
| Tenant       |          | —      |         |         |               |           |          |            |         |            |          |       |        |              |
| Session      | ✔        | ✔      | —       |         |               |           |          |            |         |            |          |       |        |              |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |            |         |            |          |       |        |              |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |          |            |         |            |          |       |        |              |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |          |            |         |            |          |       |        |              |
| Registry     |          |        |         |         |               |           | —        |            |         |            |          |       |        |              |
| Capability   |          |        |         |         |               |           |          | —          |         |            |          |       |        |              |
| Runtime      |          |        |         |         |               |           |          |            | —       |            |          |       |        |              |
| Navigation   |          |        |         |         |               |           |          |            |         | —          |          |       |        |              |
| Workflow     |          |        |         |         |               |           |          |            | ✔       |            | —        |       |        |              |
| Event        |          |        |         |         |               |           |          |            | ✔       |            | ✔        | —     |        |              |
| Ledger       |          |        |         |         |               |           |          |            | ✔       |            | ✔        | ✔     | —      |              |
| Integration  |          |        |         |         |               |           |          |            | ✔       |            | ✔        |       |        | —            |

---

## 9. Estados Canônicos

### 9.1 Estados de Workflow

| Estado | Descrição |
|--------|-----------|
| IDLE | Aguardando inicialização |
| RUNNING | Em execução |
| WAITING | Aguardando evento ou aprovação |
| SUSPENDED | Suspenso temporariamente |
| COMPLETED | Concluído com sucesso |
| FAILED | Falhou |
| CANCELLED | Cancelado |
| COMPENSATED | Compensado |

### 9.2 Regras de transição

```text
IDLE → RUNNING (inicializado)
RUNNING → WAITING (aguardando evento/aprovação)
RUNNING → COMPLETED (concluído)
RUNNING → FAILED (falha)
RUNNING → CANCELLED (cancelado)
WAITING → RUNNING (evento recebido/aprovado)
WAITING → CANCELLED (timeout ou cancelamento)
FAILED → COMPENSATING (iniciando compensação)
COMPENSATING → COMPENSATED (compensação concluída)
COMPENSATING → FAILED (compensação falhou)
SUSPENDED → RUNNING (reativado)
RUNNING → SUSPENDED (suspenso)
```

### 9.3 Regras de negócio

- Toda transição de Workflow deve ser autorizada por Authorization quando aplicável.
- Toda transição de Workflow deve gerar evento no Ledger.
- Workflow nunca executa operação diretamente; sempre via Runtime.
- Workflow nunca altera regras de negócio; apenas coordena fluxo.
- Workflow nunca expõe dados sensíveis em eventos.
- Compensação deve ser idempotente.
- Timeout de Workflow deve ser configurável por tenant.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Workflow é o primeiro domínio da **Integration Layer**.

É a ponte entre a execução controlada (Runtime) e a comunicação externa (Integration), produzindo eventos para governança (Event/Ledger).

```text
Cliente
  ↓
Identity (quem é?)
  ↓
Tenant (onde opera?)
  ↓
Session (está autorizado agora?)
  ↓
Context (em qual escopo operacional?)
  ↓
Authorization (pode?)
  ↓
Registry (o que existe?)
  ↓
Discovery (o que está disponível?)
  ↓
Capability (o que cada item representa?)
  ↓
Runtime (executa)
  ↓
Workflow (coordena processos)
  ↓
Event (comunica fatos)
  ↓
Ledger (registra evidências)
  ↓
Integration (integra externamente)
```

### 10.2 Contratos

Workflow não é uma SP. Workflow é um conceito.

Sua materialização será:
- Tabelas: `workflow_process`, `workflow_state`, `workflow_transition`, `workflow_history`, etc.
- SPs: `sp_workflow_start`, `sp_workflow_transition`, `sp_workflow_compensate`, `sp_workflow_get`, etc.
- Views: `vw_workflow_active`, `vw_workflow_history`, `vw_workflow_pending`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Workflow é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Runtime | Workflow executa transições via Runtime |
| Authorization | Workflow valida permissão para transições |
| Event | Workflow produz eventos de mudança de estado |
| Ledger | Ledger persiste eventos de Workflow |
| Integration | Integration expõe Workflow externamente |
| Navigation | Navigation projeta estado de Workflow |
| Discovery | Discovery pode descobrir workflows disponíveis |
| Capability | Workflow pode ser uma Capability |
| Registry | Workflow está registrado no Registry |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza coordenação de processos complexos.
- Torna fluxos auditáveis e rastreáveis.
- Suporta compensação e resiliência.
- Separa coordenação de regra de negócio.
- Cria base para automação governada.
- Permite composição de workflows.
- Gera eventos automáticos para Event e Ledger.

### 11.2 Impactos negativos / Riscos

- Complexidade de modelagem: workflows podem ser muito rígidos ou muito flexíveis.
- Performance: orquestração de workflows pode ser custosa.
- Migração: fluxos legados precisam ser mapeados para workflows.
- Governança: workflows sem dono ficam obsoletos.
- Acoplamento: cuidado para não acoplar Workflow a regras de negócio.

### 11.3 Mitigações

- Padrões de modelagem de workflow documentados.
- Limites de profundidade de orquestração.
- Dono definido para cada workflow.
- Testes de transição automatizados.
- Dashboard de health de workflows por tenant.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de workflow será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de workflow será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de workflow deve estar coerente com as SPs que a consomem.
12.4 Todo índice de workflow deve suportar as consultas mais frequentes (busca por tenant, estado, processo).
12.5 Nenhuma transição de workflow pode existir sem validação de Authorization quando aplicável.
12.6 Toda transição de Workflow deve gerar evento no Ledger.
12.7 Workflow não pode conter regra de negócio; apenas coordenação de estados.
12.8 Workflow deve ser a única camada autorizada a orquestrar processos complexos.
12.9 A materialização depende da aprovação do MD-KERNEL-011 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MD-KERNEL-004 — Context
- MD-KERNEL-005 — Authorization
- MD-KERNEL-006 — Discovery
- MD-KERNEL-007 — Registry
- MD-KERNEL-008 — Capability
- MD-KERNEL-009 — Runtime
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-011 — Workflow |

---

Documento Canônico — MD-KERNEL-011

**Este é o décimo primeiro domínio do Kernel Enterprise. Pertence à Integration Layer, depende de Runtime, e é pré-requisito para Event, Ledger e Integration.**
