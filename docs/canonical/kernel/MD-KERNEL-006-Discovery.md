# MD-KERNEL-006 — Discovery

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Runtime Layer
Pré-requisito: MD-KERNEL-001 — Identity
Pré-requisito: MD-KERNEL-002 — Tenant
Pré-requisito: MD-KERNEL-003 — Session
Pré-requisito: MD-KERNEL-004 — Context
Pré-requisito: MD-KERNEL-005 — Authorization
```

---

## 1. Objetivo

Definir o conceito canônico de **Discovery** no Kernel Enterprise.

Discovery é a camada responsável por responder:

> **"Quais elementos da plataforma podem ser conhecidos neste contexto?"**

Ele não é um menu.
Ele não é uma permissão.
Ele é a **ponte entre o estado resolvido do Kernel e as capacidades disponíveis**, transformando o que existe no Registry em conhecimento útil para o Runtime, sem decidir permissão, sem executar operação e sem representar navegação.

Sem Discovery, o Runtime não sabe o que existe.
Sem Authorization, o Discovery não decide o que mostrar.

---

## 2. Definição Canônica

```text
Discovery representa o processo de resolução
e filtragem de capacidades, módulos, ferramentas
e recursos disponíveis para uma identidade autenticada,
dentro de um tenant válido, em uma sessão ativa,
um contexto operacional resolvido e uma autorização válida.

Discovery é:
  - um resolvedor
  - um filtro contextual
  - uma ponte entre Registry e Runtime
  - dependente de Authorization
  - independente de tecnologia
  - sem efeito colateral de execução

Sem Discovery:
  Runtime existe,
  Registry existe,
  mas
  o sistema não sabe o que pode oferecer
  àquele contexto específico.
```

### 2.1 Princípio fundamental

```text
Discovery não decide.
Discovery não executa.
Discovery apenas responde:
  "O que existe
   e está disponível
   para este contexto?"
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Resolvedor | Transforma catálogo estático em conhecimento contextual |
| Filtrado | Respeita resultados de Authorization |
| Dependente | Requer Identity, Tenant, Session, Context e Authorization válidos |
| Leitor | Apenas consulta; não modifica estado |
| Sem efeito colateral | Não cria, altera ou executa operações |
| Auditável | Toda consulta de discovery pode ser registrada |
| Extensível | Novas capabilities entram no Registry e são automaticamente descobertas |
| Transversal | Serve a todos os produtos da plataforma |

---

## 3. Boundaries

### 3.1 Discovery É

- O resolvedor de "o que está disponível".
- O filtro entre Registry e Runtime.
- A camada que combina catálogo com contexto.
- A fonte de informação para Navigation.
- O mecanismo que evita hardcoding de módulos no frontend.

### 3.2 Discovery NÃO é

- ❌ **Authorization**: não decide permissão.
- ❌ **Menu**: não projeta interface de navegação.
- ❌ **Permissão**: não define regras de acesso.
- ❌ **Registry**: não é o catálogo em si.
- ❌ **Capability**: não representa uma capacidade individual.
- ❌ **Runtime**: não executa operação.
- ❌ **Regra de negócio**: não define fluxos operacionais.
- ❌ **Frontend**: não exibe nada diretamente.
- ❌ **Cache definitivo**: é derivado, não fonte da verdade.

### 3.3 Limites claros

```text
DISCOVERY
  │
  ├── É responsável por: descoberta, filtragem, resolução de disponibilidade
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── catálogo (Registry)
        ├── capacidade individual (Capability)
        ├── execução (Runtime)
        ├── navegação (Navigation)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Resolver quais capabilities, módulos e recursos estão disponíveis para o contexto atual.
4.2 Aplicar filtros de Authorization sobre o catálogo do Registry.
4.3 Combinar atributos de Identity, Tenant, Session, Context e Authorization para determinar disponibilidade.
4.4 Fornecer lista estruturada de recursos descobertos para o Runtime.
4.5 Suportar consultas pontuais e projeções completas de disponibilidade.
4.6 Garantir que nenhum recurso indisponível seja exposto.
4.7 Manter-se independente de tecnologia, produto e interface.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Discovery Runtime | Executa o processo de descoberta |
| Administração da Plataforma | Publica capabilities no Registry |
| Administração do Tenant | Habilita/desabilita capabilities por tenant |
| Desenvolvedor de Capability | Registra capability no Registry com metadados |
| IA | Analisa padrões de descoberta para sugerir otimizações (não decide) |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Runtime | Consulta Discovery para saber o que pode executar |
| Navigation | Usa Discovery para projetar menu e navegação |
| Registry | Fornece catálogo que Discovery filtra |
| Capability | É descoberta por Discovery |
| Portal | Consulta Discovery para montar workspace |
| Workflow | Descobre workflows disponíveis no contexto |
| Integration | Descobre integrações habilitadas |
| Notification | Descobre canais de notificação disponíveis |
| IA | Descobre capacidades disponíveis para sugerir ações |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Discovery
  │
  ├── Identity (quem está operando)
  │
  ├── Tenant (onde opera)
  │
  ├── Session (qual sessão)
  │
  ├── Context (qual contexto operacional)
  │
  ├── Authorization (quais permissões)
  │
  ├── Registry (catálogo de capabilities)
  │
  ├── 1:N → Runtime (capacidades disponíveis)
  │
  ├── 1:N → Navigation (projeção de navegação)
  │
  └── 1:N → Event (eventos de descoberta)
```

### 7.2 Modelo conceitual

```text
Registry (catálogo completo)
  │
  ├── Capability A
  ├── Capability B
  ├── Capability C
  └── Capability D
        │
        ▼
Discovery Engine
  │
  ├── Entrada:
  │     ├── Identity
  │     ├── Tenant
  │     ├── Session
  │     ├── Context
  │     └── Authorization
  │
  ├── Processo:
  │     ├── Carrega catálogo do Registry
  │     ├── Aplica filtros de Authorization
  │     ├── Resolve disponibilidade por contexto
  │     └── Ordena por relevância
  │
  └── Saída:
        ├── Capability A (disponível)
        ├── Capability C (disponível)
        └── Capability D (indisponível — sem autorização)
```

### 7.3 Separação conceitual

```text
REGISTRY
  │
  └── "Qual catálogo existe?"
        │
        ▼
AUTHORIZATION
  │
  └── "O que é permitido?"
        │
        ▼
DISCOVERY
  │
  └── "O que está disponível para este contexto?"
        │
        ▼
CAPABILITY
  │
  └── "O que cada item disponível representa?"
        │
        ▼
NAVIGATION
  │
  └── "Como projetar isso para o usuário?"
        │
        ▼
PORTAL
  │
  └── "O que o usuário vê e interage?"
```

Cada camada responde uma pergunta diferente.
Discovery é o resolvedor de disponibilidade.

### 7.4 Discovery não é menu

```text
PROIBIDO:

Menu
  ↓
Permissão
  ↓
Autorização

Isso foi um problema histórico.
Menu é projeção, não fonte.

CORRETO:

Capability
      ↓
Authorization
      ↓
Discovery
      ↓
Navigation Projection
      ↓
Portal
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Discovery resolve para uma identidade específica |
| Tenant | Discovery opera dentro de um tenant |
| Session | Discovery valida sessão ativa |
| Context | Discovery aplica contexto operacional |
| Authorization | Discovery filtra por decisões de acesso |
| Registry | Discovery consulta o catálogo de capabilities |

### 8.2 É dependido por

| Domínio | Como depende de Discovery |
|---------|----------------------------|
| Registry | Registry é a fonte de Discovery |
| Capability | Capability é descoberta por Discovery |
| Runtime | Runtime consulta Discovery antes de executar |
| Navigation | Navigation projeta menu baseado em Discovery |
| Workflow | Workflow descobre workflows disponíveis |
| Integration | Integration descobre integrações disponíveis |
| Notification | Notification descobre canais disponíveis |
| Portal | Portal monta workspace baseado em Discovery |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- |
| Identity     | —        |        |         |         |               |           |
| Tenant       |          | —      |         |         |               |           |
| Session      | ✔        | ✔      | —       |         |               |           |
| Context      | ✔        | ✔      | ✔       | —       |               |           |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |
| Registry     |          |        |         |         |               | ✔         |
| Capability   |          |        |         |         |               | ✔         |
| Runtime      |          |        |         |         |               | ✔         |
| Navigation   |          |        |         |         |               | ✔         |
| Workflow     |          |        |         |         |               | ✔         |
| Event        |          |        |         |         |               | ✔         |
| Ledger       |          |        |         |         |               | ✔         |
| Integration  |          |        |         |         |               | ✔         |

---

## 9. Estados Canônicos

### 9.1 Estados de Discovery

| Estado | Descrição |
|--------|-----------|
| IDLE | Aguardando solicitação de descoberta |
| RESOLVING | Processando catálogo e filtros |
| RESOLVED | Descoberta concluída com sucesso |
| PARTIAL | Parte do catálogo indisponível para o contexto |
| EMPTY | Nenhuma capability disponível para o contexto |
| ERROR | Falha no processo de descoberta |

### 9.2 Regras de transição

```text
IDLE → RESOLVING (solicitação recebida)
RESOLVING → RESOLVED (catálogo filtrado com sucesso)
RESOLVING → PARTIAL (algumas capabilities indisponíveis)
RESOLVING → EMPTY (nenhuma capability disponível)
RESOLVING → ERROR (falha no processo)
RESOLVED → IDLE (nova solicitação)
PARTIAL → RESOLVING (nova consulta)
EMPTY → RESOLVING (nova consulta)
ERROR → IDLE (após correção)
```

### 9.3 Regras de negócio

- Discovery é sempre leitura; nunca modifica estado.
- Discovery respeita Authorization; capabilities negadas não são descobertas.
- Discovery é tenant-aware; nunca cruza tenant sem autorização explícita.
- Discovery pode ser cacheado; invalidação depende de Authorization, Registry e Context.
- Toda descoberta relevante pode gerar evento no Ledger.
- Discovery não expõe metadados sensíveis de capabilities não autorizadas.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Discovery é o primeiro domínio da **Runtime Layer**.

É a ponte entre Foundation + Governance e o resto do Runtime.

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
Discovery (o que existe para este contexto?)
  ↓
Registry (catálogo)
  ↓
Capability (capacidade individual)
  ↓
Runtime (executa)
```

### 10.2 Contratos

Discovery não é uma SP. Discovery é um conceito.

Sua materialização será:
- Tabelas: `discovery_cache`, `discovery_history`, etc.
- SPs: `sp_discovery_resolve`, `sp_discovery_query`, `sp_discovery_invalidate`, etc.
- Views: `vw_discovery_available`, `vw_discovery_by_context`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Discovery é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Discovery resolve para uma identidade |
| Tenant | Discovery opera dentro de um tenant |
| Session | Discovery valida sessão ativa |
| Context | Discovery aplica contexto operacional |
| Authorization | Discovery filtra por decisões de acesso |
| Registry | Registry é o catálogo que Discovery consulta |
| Capability | Capability é descoberta por Discovery |
| Runtime | Runtime usa Discovery para executar capabilities |
| Navigation | Navigation projeta menu baseado em Discovery |
| Workflow | Workflow descobre workflows disponíveis |
| Event | Evento registra descobertas relevantes |
| Ledger | Ledger persiste histórico de descobertas |
| Integration | Integration descobre integrações disponíveis |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Elimina hardcoding de módulos no frontend.
- Centraliza a lógica de "o que está disponível".
- Torna a navegação dinâmica e contextual.
- Suporta multi-tenant e multi-contexto naturalmente.
- Permite evolução de capabilities sem alterar produtos consumidores.
- Cria base para experiência unificada da plataforma.
- Separa claramente descoberta de execução.

### 11.2 Impactos negativos / Riscos

- Complexidade de resolução: filtros podem ser numerosos.
- Performance: descoberta é consultada em toda navegação.
- Cache inválido: mudança de Authorization sem invalidação expõe recursos indevidos.
- Migração: produtos legados precisam migrar de menu hardcoded para Discovery.
- Governança: capabilities sem dono poluem o catálogo.

### 11.3 Mitigações

- Motor de descoberta otimizado com índices adequados.
- Política de invalidação de cache atrelada a Authorization e Registry.
- Metadados obrigatórios para toda capability registrada.
- Migração gradual por produto.
- Dashboard de health de Discovery por tenant.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de discovery será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de discovery será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de discovery deve estar coerente com as SPs que a consomem.
12.4 Todo índice de discovery deve suportar as consultas mais frequentes (busca por identity, tenant, contexto, capability).
12.5 Nenhuma operação do Runtime pode existir sem Discovery resolvido quando houver dependência de capabilities.
12.6 Toda resolução de Discovery deve gerar evento no Ledger quando relevante.
12.7 Discovery nunca modifica estado; é puramente consulta.
12.8 A materialização depende da aprovação do MD-KERNEL-006 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MD-KERNEL-004 — Context
- MD-KERNEL-005 — Authorization
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-033 — Authorization is Decision
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-006 — Discovery |

---

Documento Canônico — MD-KERNEL-006

**Este é o sexto domínio do Kernel Enterprise. Depende de Foundation Layer e Authorization, e é pré-requisito para Registry, Capability, Runtime e Navigation.**
