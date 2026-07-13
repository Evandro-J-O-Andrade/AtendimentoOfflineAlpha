# MD-KERNEL-014 — Integration

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Integration Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-009 — Runtime
Pré-requisito: MD-KERNEL-011 — Workflow
Pré-requisito: MD-KERNEL-012 — Event
Pré-requisito: MD-KERNEL-013 — Ledger
Consumido por: Todos os produtos e sistemas externos
```

---

## 1. Objetivo

Definir o conceito canônico de **Integration** no Kernel Enterprise.

Integration é a camada responsável por responder:

> **"Como o Kernel se conecta com sistemas, produtos e ecossistemas externos?"**

Ele não é uma API.
Ele não é um webhook.
Ele é o **mecanismo de interoperabilidade** do Kernel, permitindo que produtos consumidores, sistemas externos e ecossistemas se conectem à plataforma de forma controlada, governada e desacoplada.

Sem Integration, o Kernel funciona isolado.
Sem o Kernel, Integration não tem governança.

---

## 2. Definição Canônica

```text
Integration representa o conjunto de mecanismos
que conectam o Kernel Enterprise com sistemas,
produtos e ecossistemas externos.

Integration é:
  - um conector
  - um adaptador de protocolos
  - um contratualizador de comunicação
  - um orquestrador de integrações externas
  - independente de produto específico
  - governado pelo Kernel
  - produtor e consumidor de Event

Integration não responde:
  "qual é a regra de negócio?"
  "quem pode acessar?"
  "como executar a operação interna?"

Integration responde:
  "como conectar este sistema externo
   respeitando identidade, tenant, sessão,
   contexto, autorização e evidência?"
```

### 2.1 Princípio fundamental

```text
Integration conecta sem acoplar.
Integration governa sem invadir.
Integration adapta sem alterar o Kernel.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Adaptadora | Converte formatos externos para o Kernel e vice-versa |
| Governada | Toda integração passa por Authorization e Registry |
| Desacoplada | Não cria dependência direta entre sistemas |
| Rastreável | Toda integração gera evidência no Ledger |
| Multi-formato | Suporta API REST, GraphQL, SOAP, mensageria, arquivos |
| Multi-protocolo | Suporta HTTP, gRPC, AMQP, Kafka, SFTP, etc. |
| Resiliente | Suporta retry, timeout, circuit breaker, fallback |
| Auditável | Toda comunicação é registrada no Ledger |

### 2.3 Tipos de Integração

| Tipo | Natureza | Observação |
|------|----------|------------|
| API | Integração síncrona via API | Ex: REST, GraphQL, SOAP |
| Mensageria | Integração assíncrona via fila | Ex: RabbitMQ, Kafka, SQS |
| Arquivo | Integração via transferência de arquivo | Ex: CSV, XML, JSON, HL7 |
| Webhook | Integração reativa via callback | Ex: notificação de evento externo |
| ETL | Integração via extração e carga | Ex: BI, Data Lakehouse |
| Stream | Integração via streaming contínuo | Ex: Kafka, WebSocket |
| Batch | Integração via processamento em lote | Ex: conciliação, fechamento |

---

## 3. Boundaries

### 3.1 Integration É

- O mecanismo de conexão do Kernel com o exterior.
- O adaptador entre formatos externos e o Kernel.
- O contratualizador de comunicação.
- O orquestrador de integrações externas.
- O produtor e consumidor de eventos externos.
- A camada que garante governança em integrações.
- O habilitador de ecossistema.

### 3.2 Integration NÃO é

- ❌ **API pública descontrolada**: não expõe funcionalidades sem governança.
- ❌ **Webhook sem contrato**: não aceita callbacks arbitrários.
- ❌ **Regra de negócio**: não define fluxos operacionais.
- ❌ **Runtime**: não executa operações internas do Kernel.
- ❌ **Event**: não é o mecanismo de comunicação interna.
- ❌ **Ledger**: não registra evidências; consome Ledger.
- ❌ **Frontend**: não exibe interface.
- ❌ **Produto**: não é HIS, ERP, CRM ou aplicação final.

### 3.3 Limites claros

```text
INTEGRATION
  │
  ├── É responsável por: conexão externa, adaptação, contrato, governança
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
        ├── comunicação interna (Event)
        ├── registro histórico (Ledger)
        └── regra de negócio (Domínio consumidor)
```

---

## 4. Responsabilidades

4.1 Conectar o Kernel com sistemas externos de forma governada.
4.2 Adaptar formatos e protocolos externos para o Kernel.
4.3 Validar identidade, tenant, sessão e contexto em toda comunicação externa.
4.4 Aplicar Authorization em toda integração.
4.5 Registrar toda comunicação no Ledger.
4.6 Suportar múltiplos formatos e protocolos.
4.7 Garantir resiliência: retry, timeout, circuit breaker, fallback.
4.8 Gerenciar contratos de integração.
4.9 Suportar transformação de dados entre formatos.
4.10 Garantir isolamento multi-tenant em toda comunicação.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Administração da Plataforma | Define integrações estruturais |
| Desenvolvedor de Integração | Implementa conectores |
| Administração do Tenant | Habilita/desabilita integrações por tenant |
| IA | Analisa padrões de integração para sugerir otimizações (não decide) |
| Parceiros | Registram integrações via Registry |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Sistemas externos | Consomem APIs e endpoints do Kernel |
| HIS | Consome Kernel para dados assistenciais |
| ERP | Consome Kernel para dados financeiros |
| CRM | Consome Kernel para dados de relacionamento |
| BI | Consome Kernel para dados analíticos |
| Mobile | Consome Kernel para dados móveis |
| Display / TV | Consome Kernel para dados de painéis |
| Totem | Consome Kernel para autoatendimento |
| Parceiros | Consomem Kernel via integrações contratuais |
| IA | Consome Kernel para dados de aprendizado |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Integration
  │
  ├── Kernel (fonte de dados)
  │     ├── Identity
  │     ├── Tenant
  │     ├── Session
  │     ├── Context
  │     ├── Authorization
  │     ├── Capability
  │     ├── Runtime
  │     ├── Workflow
  │     ├── Event
  │     └── Ledger
  │
  ├── External System (destino)
  │     ├── HIS
  │     ├── ERP
  │     ├── CRM
  │     ├── BI
  │     ├── Mobile
  │     ├── Display
  │     ├── Totem
  │     └── Parceiros
  │
  ├── Adapter (adaptador de formato)
  │
  ├── Contract (contrato de integração)
  │
  ├── 1:N → Event (eventos externos)
  │
  └── 1:N → Ledger (evidências de integração)
```

### 7.2 Modelo conceitual

```text
Sistema Externo solicita dado
  │
  ├── Ex: HIS solicita prontuário
  ├── Ex: ERP solicita faturamento
  ├── Ex: BI solicita métricas
  │
  ▼
Integration Engine
  │
  ├── Valida identidade do sistema externo
  ├── Valida tenant autorizado
  ├── Valida sessão/contexto
  ├── Aplica Authorization
  ├── Adapta formato externo → Kernel
  ├── Executa via Runtime
  ├── Registra no Ledger
  ├── Gera Event
  ├── Adapta formato Kernel → externo
  └── Retorna resposta
        │
        ▼
  Sistema Externo recebe dado
```

### 7.3 Integration como camada de adaptação

```text
INTEGRATION
  │
  ├── Kernel (formato canônico)
  │     └── Identity, Tenant, Session, Context, Authorization, Capability, Runtime, Workflow, Event, Ledger
  │
  ├── Adapter (conversão)
  │     └── Formato canônico ↔ Formato externo
  │
  └── External System (formato legado)
        └── HIS, ERP, CRM, BI, Mobile, Display, Totem, Parceiros
```

Integration não altera o Kernel para se adaptar a sistemas externos.
Integration adapta o formato externo para o Kernel.

### 7.4 Separação de conceitos

```text
INTEGRATION
  │
  ├── NÃO é API descontrolada
  │     └── API sem governança é risco
  │
  ├── NÃO é Webhook arbitrário
  │     └── Webhook sem contrato é risco
  │
  ├── NÃO é Runtime
  │     └── Runtime executa interno; Integration conecta externo
  │
  ├── NÃO é Event
  │     └── Event é comunicação interna; Integration adapta externo
  │
  ├── NÃO é Ledger
  │     └── Ledger registra; Integration consome Ledger
  │
  ├── NÃO é Regra de Negócio
  │     └── Regra de negócio mora no domínio consumidor
  │
  └── NÃO é Produto
        └── Produto consome Integration; Integration não é produto
```

### 7.5 Integration e ecossistema

```text
Kernel Enterprise
  │
  ├── Integration
  │     ├── HIS (sistema legado)
  │     ├── ERP (sistema financeiro)
  │     ├── CRM (relacionamento)
  │     ├── BI (analytics)
  │     ├── Mobile (aplicativo móvel)
  │     ├── Display / TV (painéis)
  │     ├── Totem (autoatendimento)
  │     ├── Parceiros (ecossistema)
  │     └── Marketplace (apps terceiras)
```

Todos os produtos consumidores devem se conectar via Integration.
Nenhum produto deve acessar o Kernel diretamente.

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Integration valida identidade de sistemas externos |
| Tenant | Integration opera dentro de tenants autorizados |
| Session | Integration valida sessão quando aplicável |
| Context | Integration aplica contexto operacional |
| Authorization | Integration aplica Authorization em toda comunicação |
| Registry | Integration consulta Registry para contratos de integração |
| Capability | Integration expõe Capability para externo |
| Runtime | Integration executa via Runtime |
| Workflow | Integration coordena workflows externos |
| Event | Integration consome e produz Event |
| Ledger | Integration registra evidências no Ledger |

### 8.2 É dependido por

| Domínio | Como depende de Integration |
|---------|------------------------------|
| Sistemas externos | Consomem APIs e endpoints do Kernel via Integration |
| HIS | Consome Integration para dados assistenciais |
| ERP | Consome Integration para dados financeiros |
| CRM | Consome Integration para dados de relacionamento |
| BI | Consome Integration para dados analíticos |
| Mobile | Consome Integration para dados móveis |
| Display | Consome Integration para dados de painéis |
| Totem | Consome Integration para autoatendimento |
| Parceiros | Consomem Integration via contratos |

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
| Event        |          |        |         |         |               |           |          |            |         |            | ✔        | —     |        |              |
| Ledger       |          |        |         |         |               |           |          |            |         |            | ✔        | ✔     | —      |              |
| Integration  | ✔        | ✔      | ✔       | ✔       | ✔             |           |          |            | ✔       |            | ✔        | ✔     | ✔      | —            |

---

## 9. Estados Canônicos

### 9.1 Estados de Integração

| Estado | Descrição |
|--------|-----------|
| IDLE | Aguardando solicitação |
| CONNECTING | Estabelecendo conexão |
| CONNECTED | Conexão estabelecida |
| AUTHENTICATING | Autenticando sistema externo |
| AUTHENTICATED | Sistema externo autenticado |
| AUTHORIZING | Aplicando Authorization |
| AUTHORIZED | Autorização concedida |
| TRANSFORMING | Adaptando formato |
| EXECUTING | Executando integração |
| RESPONDING | Retornando resposta |
| COMPLETED | Integração concluída |
| FAILED | Integração falhou |
| RETRY | Em retry |
| DEAD_LETTER | Falha definitiva |

### 9.2 Regras de transição

```text
IDLE → CONNECTING (solicitação recebida)
CONNECTING → CONNECTED (conexão estabelecida)
CONNECTING → FAILED (falha na conexão)
CONNECTED → AUTHENTICATING (iniciando autenticação)
AUTHENTICATING → AUTHENTICATED (autenticado)
AUTHENTICATING → FAILED (falha na autenticação)
AUTHENTICATED → AUTHORIZING (iniciando autorização)
AUTHORIZING → AUTHORIZED (autorizado)
AUTHORIZING → FAILED (não autorizado)
AUTHORIZED → TRANSFORMING (adaptando formato)
TRANSFORMING → EXECUTING (executando)
EXECUTING → RESPONDING (retornando resposta)
RESPONDING → COMPLETED (concluído)
EXECUTING → FAILED (falha na execução)
FAILED → RETRY (tentando novamente)
RETRY → COMPLETED (sucesso)
RETRY → FAILED (falha novamente)
FAILED → DEAD_LETTER (esgotadas tentativas)
```

### 9.3 Regras de negócio

- Toda integração deve passar por Authorization.
- Toda integração deve ser registrada no Ledger.
- Toda integração deve respeitar isolamento multi-tenant.
- Sistemas externos devem ser autenticados antes de qualquer operação.
- Integração deve ser resiliente: retry, timeout, circuit breaker.
- Integração não deve expor dados de um tenant para outro.
- Contratos de integração devem ser versionados.
- Falhas de integração devem gerar eventos no Ledger.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Integration é o único domínio da **Integration Layer**.

É a camada que fecha o ciclo do Kernel, conectando-o com o mundo externo e permitindo que produtos consumidores acessem a plataforma de forma governada.

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
Navigation (apresenta)
  ↓
Workflow (coordena processos)
  ↓
Event (comunica fatos)
  ↓
Ledger (preserva evidências)
  ↓
Integration (conecta externamente)
```

### 10.2 Contratos

Integration não é uma SP. Integration é um conceito.

Sua materialização será:
- Tabelas: `integration_registry`, `integration_adapter`, `integration_contract`, `integration_history`, etc.
- SPs: `sp_integration_connect`, `sp_integration_authenticate`, `sp_integration_execute`, `sp_integration_transform`, etc.
- Views: `vw_integration_active`, `vw_integration_by_tenant`, `vw_integration_contracts`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Integration é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Integration valida identidade de sistemas externos |
| Tenant | Integration opera dentro de tenants autorizados |
| Session | Integration valida sessão quando aplicável |
| Context | Integration aplica contexto operacional |
| Authorization | Integration aplica Authorization em toda comunicação |
| Discovery | Integration consulta Discovery para capabilities disponíveis |
| Registry | Integration consulta Registry para contratos |
| Capability | Integration expõe Capability para externo |
| Runtime | Integration executa via Runtime |
| Navigation | Integration projeta navegação para consumidores externos |
| Workflow | Integration coordena workflows externos |
| Event | Integration consome e produz Event |
| Ledger | Integration registra evidências no Ledger |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Conecta o Kernel com o ecossistema externo de forma governada.
- Permite que produtos consumidores acessem a plataforma sem acoplamento.
- Torna integrações rastreáveis e auditáveis.
- Suporta múltiplos formatos e protocolos.
- Cria base para ecossistema de parceiros.
- Separa claramente interno de externo.
- Habilita composição de produtos.

### 11.2 Impactos negativos / Riscos

- Complexidade de adaptação: múltiplos formatos e protocolos.
- Performance: integrações podem ser lentas ou indisponíveis.
- Segurança: exposição de dados sensíveis para externo.
- Custo: manutenção de contratos de integração.
- Governança: integrações sem dono ficam obsoletas.
- Acoplamento: cuidado para não criar dependência reversa.

### 11.3 Mitigações

- Contratos de integração documentados e versionados.
- Autenticação e Authorization obrigatórias.
- Timeout e circuit breaker em toda integração.
- Monitoramento de health de integrações.
- Política de depreciação de contratos.
- Dashboard de integrações por tenant.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de integration será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de integration será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de integration deve estar coerente com as SPs que a consomem.
12.4 Todo índice de integration deve suportar as consultas mais frequentes (busca por tenant, sistema externo, contrato).
12.5 Nenhuma integração pode existir sem contrato documentado e Authorization.
12.6 Toda integração deve gerar evento no Ledger.
12.7 Integration não pode expor dados de um tenant para outro.
12.8 Integration deve ser a única porta de entrada/saída para sistemas externos.
12.9 A materialização depende da aprovação do MD-KERNEL-014 e do dossiê correspondente.

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
- MD-KERNEL-012 — Event
- MD-KERNEL-013 — Ledger
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
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-014 — Integration |

---

Documento Canônico — MD-KERNEL-014

**Este é o décimo quarto e último domínio do Kernel Enterprise. Pertence à Integration Layer, depende de todos os domínios do Kernel, e fecha o ciclo arquitetural.**
