# MD-KERNEL-012 — Event

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Governance Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-005 — Authorization
Pré-requisito: MD-KERNEL-011 — Workflow
Consumido por: MD-KERNEL-013 — Ledger
Consumido por: MD-KERNEL-014 — Integration
Consumido por: Todos os domínios do Kernel
```

---

## 1. Objetivo

Definir o conceito canônico de **Event** no Kernel Enterprise.

Event é a camada responsável por responder:

> **"O que aconteceu dentro da plataforma?"**

Ele não é um log.
Ele não é uma auditoria.
Ele é a **declaração imutável de que um fato ocorreu** dentro do Kernel, permitindo comunicação desacoplada entre domínios e produtos.

Sem Event, o Kernel não comunica mudanças.
Sem Event, sistemas externos não reagem ao que acontece.
Sem Ledger, Event não tem prova histórica.

---

## 2. Definição Canônica

```text
Event representa um fato consumado ocorrido
dentro da plataforma New Wave Enterprise.

Event é:
  - uma declaração de fato
  - imutável
  - timestamped
  - contextualizada
  - desacoplada
  - consumível por múltiplos interessados
  - produtor de evidências para o Ledger

Event não responde:
  "quem pode fazer?"
  "qual é o estado anterior?"
  "onde guardar a prova?"
  "quem foi notificado?"

Event responde:
  "o que aconteceu,
   quando aconteceu,
   onde aconteceu
   e quem estava envolvido?"
```

### 2.1 Princípio fundamental

```text
Event é comunicação de fato consumado.
Event não é log.
Event não é auditoria.
Event não é comando.
Event é a base para comunicação desacoplada
e para geração de evidências no Ledger.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Imutável | Event não pode ser alterado ou deletado |
| Temporal | Event carrega timestamp exato do ocorrido |
| Contextualizado | Event carrega identity, tenant, session e contexto |
| Desacoplado | Event não conhece o consumidor |
| Granular | Event representa um fato específico, não um conjunto |
| Rastreável | Event pode ser ligado a outros eventos e ao Ledger |
| Consumível | Event pode ser consumido por múltiplos sistemas |
| Auditável | Event é fonte para geração de evidências |

### 2.3 Tipos de Event

| Tipo | Natureza | Observação |
|------|----------|------------|
| Domínio | Ocorrido em um domínio específico | Ex: AtendimentoCriado, PrescriçãoDispensada |
| Sistema | Ocorrido na infraestrutura | Ex: SessaoExpirada, SyncConcluido |
| Integração | Ocorrido em integração externa | Ex: TASYAtualizado, CartorioRecebido |
| Governança | Ocorrido em decisão de acesso | Ex: AcessoPermitido, AcessoNegado |
| Negócio | Ocorrido em processo operacional | Ex: FaturamentoProcessado, EstoqueAtualizado |

---

## 3. Boundaries

### 3.1 Event É

- A declaração de que um fato consumado ocorreu.
- O mecanismo de comunicação desacoplada do Kernel.
- A fonte para geração de evidências no Ledger.
- O registrador de mudanças relevantes no sistema.
- A base para reação de outros componentes.
- O mecanismo que permite integração sem acoplamento direto.

### 3.2 Event NÃO é

- ❌ **Log**: não armazena histórico completo de execução.
- ❌ **Auditoria**: não é a prova histórica definitiva.
- ❌ **Ledger**: não registra evidências imutáveis.
- ❌ **Comando**: não solicita ação.
- ❌ **Query**: não consulta estado.
- ❌ **Permissão**: não decide acesso.
- ❌ **Regra de negócio**: não define fluxos.
- ❌ **Notificação**: não endereça mensagens a usuários.
- ❌ **Workflow**: não coordena transições.

### 3.3 Limites claros

```text
EVENT
  │
  ├── É responsável por: comunicação de fato, desacoplamento, notificação de ocorrência
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
        ├── coordenação de processos (Workflow)
        ├── registro histórico (Ledger)
        ├── integração externa (Integration)
        └── regra de negócio (Domínio consumidor)
```

---

## 4. Responsabilidades

4.1 Declarar fatos consumados ocorridos na plataforma.
4.2 Carregar contexto mínimo necessário para compreensão do fato.
4.3 Permitir consumo por múltiplos interessados sem acoplamento.
4.4 Servir como fonte para geração de evidências no Ledger.
4.5 Suportar padrões de nomenclatura e estrutura canônicos.
4.6 Garantir imutabilidade de eventos publicados.
4.7 Permitir correlação entre eventos relacionados.
4.8 Suportar versionamento de contratos de evento.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Qualquer domínio do Kernel | Gera eventos quando fatos relevantes ocorrem |
| Workflow | Gera eventos de mudança de estado |
| Runtime | Gera eventos de execução |
| Authorization | Gera eventos de decisão de acesso |
| Integration | Gera eventos de integração externa |
| Administração | Gera eventos administrativos |
| IA | Gera eventos de sugestão (não decisão) |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Ledger | Consome Event para gerar evidências históricas |
| Integration | Consome Event para reagir a fatos externamente |
| Workflow | Consome Event para triggerar transições |
| Runtime | Consome Event para invalidar cache e atualizar estado |
| Navigation | Consome Event para atualizar projeção |
| Notification | Consome Event para endereçar mensagens |
| Analytics | Consome Event para métricas e dashboards |
| IA | Consome Event para sugerir ações no contexto correto |
| Auditoria | Consome Event para rastreabilidade |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Event
  │
  ├── Identity (quem estava envolvido)
  │
  ├── Tenant (onde aconteceu)
  │
  ├── Session (qual sessão)
  │
  ├── Context (qual contexto)
  │
  ├── Source (quem gerou)
  │
  ├── Timestamp (quando aconteceu)
  │
  ├── CorrelationId (agrupamento)
  │
  ├── 1:N → Ledger (evidência histórica)
  │
  └── 1:N → Consumer (interessados)
```

### 7.2 Modelo conceitual

```text
Fato ocorre no Kernel
  │
  ├── Ex: AtendimentoIniciado
  ├── Ex: PrescricaoDispensada
  ├── Ex: AcessoPermitido
  ├── Ex: SessaoExpirada
  │
  ▼
Event publicado
  │
  ├── Metadados:
  │     ├── id_evento (único)
  │     ├── timestamp
  │     ├── identity
  │     ├── tenant
  │     ├── session
  │     ├── contexto
  │     └── correlation_id
  │
  ├── Payload:
  │     └── dados específicos do evento
  │
  └── Consumidores:
        ├── Ledger → registra evidência
        ├── Integration → notifica sistema externo
        ├── Workflow → triggera transição
        ├── Runtime → atualiza cache
        ├── Navigation → atualiza projeção
        └── Analytics → atualiza métricas
```

### 7.3 Event como comunicação, não como armazenamento

```text
EVENT
  │
  ├── É: "Algo aconteceu"
  │     └── Declaração de fato
  │
  ├── NÃO É: "Histórico completo"
  │     └── Isso é Ledger
  │
  ├── NÃO É: "Prova imutável"
  │     └── Isso é Ledger
  │
  ├── NÃO É: "Log de sistema"
  │     └── Isso é infraestrutura, não Kernel
  │
  └── NÃO É: "Notificação ao usuário"
        └── Isso é Notification
```

### 7.4 Event ≠ Log

```text
EVENT
  │
  └── "AtendimentoIniciado"
        └── Fato consumado, imutável, contextualizado

LOG
  │
  └── "2026-07-13 10:00:00 INFO sp_atendimento_abrir iniciou"
        └── Execução técnica, detalhe de implementação
```

Event é semântico.
Log é técnico.

### 7.5 Event ≠ Ledger

```text
EVENT
  │
  └── "Dispensação realizada."
        └── Fato ocorreu

LEDGER
  │
  └── Registro imutável contendo:
        ├── quando
        ├── onde
        ├── por quem
        ├── qual contexto
        └── qual resultado
```

Event é a comunicação do fato.
Ledger é a prova histórica do fato.

### 7.6 Event como contrato corporativo

```text
Eventos devem representar fatos consumados (passado):

Correto:
    SenhaCriada
    AtendimentoIniciado
    DocumentoAprovado
    TreinamentoConcluido

Incorreto:
    CriarSenha
    ExecutarAtendimento
    AprovarDocumento
    ConcluirTreinamento
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Event carrega identidade envolvida |
| Tenant | Event carrega tenant do ocorrido |
| Session | Event carrega sessão ativa |
| Context | Event carrega contexto operacional |
| Authorization | Event pode carregar decisão de acesso |
| Runtime | Event carrega execução envolvida |
| Workflow | Event carrega transição de workflow |

### 8.2 É dependido por

| Domínio | Como depende de Event |
|---------|------------------------|
| Ledger | Ledger consome Event para gerar evidências |
| Integration | Integration consome Event para reagir |
| Workflow | Workflow consome Event para triggerar transições |
| Runtime | Runtime consome Event para invalidar cache |
| Navigation | Navigation consome Event para atualizar projeção |
| Notification | Notification consome Event para endereçar mensagens |
| Analytics | Analytics consome Event para métricas |
| Auditoria | Auditoria consome Event para rastreabilidade |

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
| Workflow     |          |        |         |         |               |           |          |            |         |            | —        |       |        |              |
| Event        |          |        |         |         |               |           |          |            |         |            |          | —     |        |              |
| Ledger       |          |        |         |         |               |           |          |            |         |            |          | ✔     | —      |              |
| Integration  |          |        |         |         |               |           |          |            |         |            |          | ✔     |        | —            |

---

## 9. Estados Canônicos

### 9.1 Estados de Event

| Estado | Descrição |
|--------|-----------|
| CREATED | Evento criado, aguardando publicação |
| PUBLISHED | Evento publicado e disponível para consumo |
| PROCESSED | Evento processado por consumidores |
| FAILED | Evento falhou no processamento |
| RETRY | Evento em retry |
| DEAD_LETTER | Evento falhou definitivamente |

### 9.2 Regras de transição

```text
CREATED → PUBLISHED (evento publicado)
PUBLISHED → PROCESSED (consumidores processaram)
PUBLISHED → FAILED (falha no processamento)
FAILED → RETRY (tentando novamente)
RETRY → PROCESSED (processado com sucesso)
RETRY → FAILED (falha novamente)
FAILED → DEAD_LETTER (esgotadas tentativas)
```

### 9.3 Regras de negócio

- Event é imutável; nunca alterado ou deletado.
- Event carrega timestamp exato do ocorrido.
- Event carrega contexto mínimo: identity, tenant, session, contexto.
- Event segue padrão de nomenclatura canônico: fato consumado no passado.
- Event pode ser correlacionado por correlation_id.
- Todo Event relevante é consumido por Ledger.
- Event não carrega segredos, senhas ou credenciais.
- Event é versionado; mudanças de contrato são gerenciadas.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Event é um domínio transversal da **Governance Layer**.

É o mecanismo de comunicação que conecta todos os domínios do Kernel, permitindo desacoplamento e reação a fatos ocorridos.

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

Event não é uma SP. Event é um conceito.

Sua materialização será:
- Tabelas: `event_stream`, `event_consumer`, `event_dead_letter`, etc.
- SPs: `sp_event_publish`, `sp_event_consume`, `sp_event_retry`, `sp_event_get`, etc.
- Views: `vw_event_stream`, `vw_event_by_tenant`, `vw_event_dead_letter`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Event é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Event carrega identidade envolvida |
| Tenant | Event carrega tenant do ocorrido |
| Session | Event carrega sessão ativa |
| Context | Event carrega contexto operacional |
| Authorization | Event pode registrar decisões de acesso |
| Discovery | Event pode registrar descobertas relevantes |
| Registry | Event pode registrar alterações no Registry |
| Capability | Event pode registrar execuções de Capability |
| Runtime | Event registra execuções de Runtime |
| Navigation | Event registra projeções relevantes |
| Workflow | Event registra mudanças de estado de Workflow |
| Ledger | Ledger consome Event para gerar evidências |
| Integration | Integration consome Event para reagir externamente |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Desacopla domínios da plataforma.
- Permite reação a fatos sem polling.
- Cria base para integração externa.
- Torna o sistema reativo e auditável.
- Suporta compensação e resiliência.
- Permite evolução de consumidores sem alterar produtores.
- Cria base para analytics e métricas.
- Separa comunicação de armazenamento.

### 11.2 Impactos negativos / Riscos

- Complexidade de gestão de eventos.
- Performance: volume de eventos pode ser alto.
- Ordem de eventos: eventual consistency.
- Retry e dead letter: eventos podem falhar.
- Versionamento: contratos de evento podem mudar.
- Observabilidade: rastrear fluxo de eventos pode ser difícil.

### 11.3 Mitigações

- Padrões de evento documentados.
- Versionamento de contratos de evento.
- Infraestrutura de retry e dead letter.
- Correlation ID para rastreamento.
- Dashboard de monitoramento de eventos.
- Política de TTL e retenção de eventos.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de event será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de event será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de event deve estar coerente com as SPs que a consomem.
12.4 Todo índice de event deve suportar as consultas mais frequentes (busca por tenant, tipo, timestamp, correlation_id).
12.5 Nenhum evento pode ser alterado ou deletado após publicação.
12.6 Todo evento relevante deve ser consumido por Ledger.
12.7 Event não pode carregar segredos, senhas ou credenciais.
12.8 Event deve seguir padrão de nomenclatura canônico: fato consumado no passado.
12.9 A materialização depende da aprovação do MD-KERNEL-012 e do dossiê correspondente.

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
- MD-KERNEL-010 — Navigation
- MD-KERNEL-011 — Workflow
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-036 — Contrato de Eventos Corporativos
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-012 — Event |

---

Documento Canônico — MD-KERNEL-012

**Este é o décimo segundo domínio do Kernel Enterprise. Pertence à Governance Layer, depende de todos os domínios operacionais, e é pré-requisito para Ledger e Integration.**
