# MD-KERNEL-007 — Registry

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Runtime Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Consumido por: MD-KERNEL-006 — Discovery
```

---

## 1. Objetivo

Definir o conceito canônico de **Registry** no Kernel Enterprise.

Registry é a camada responsável por responder:

> **"Quais elementos canônicos existem dentro da plataforma?"**

Ele não é um menu.
Ele não é uma permissão.
Ele é o **catálogo central e autoritativo** de todos os elementos registráveis da plataforma, independente de produto, contexto ou interface.

Registry é a base de organização do Kernel.
Sem Registry, não há Discovery consistente.

---

## 2. Definição Canônica

```text
Registry representa o catálogo central e imutável
de todos os elementos canônicos da plataforma New Wave Enterprise.

Registry é:
  - um catálogo
  - uma fonte de verdade estrutural
  - um organizador de referências
  - independente de contexto
  - independente de autorização
  - independente de produto
  - a base para Discovery

Registry não responde:
  "quem pode acessar?"
  "o que está disponível agora?"
  "como executar?"

Registry responde apenas:
  "o que existe?"
```

### 2.1 Princípio fundamental

```text
Registry é o catálogo da plataforma.
Discovery é a resolução contextual do catálogo.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Centralizado | Um único Registry para toda a plataforma |
| Autoritativo | Fonte de verdade estrutural dos elementos |
| Imutável | Registros não são alterados; atualizações são novas versões |
| Independente | Não depende de contexto, autorização ou produto |
| Identificador | Todo elemento registrado tem identificação única canônica |
| Metadatado | Todo elemento carrega metadados obrigatórios |
| Extensível | Novos elementos entram sem alterar a estrutura do Registry |
| Auditável | Toda inclusão, alteração de status e remoção é registrada |

### 2.3 Tipos de elementos registráveis

| Tipo | Natureza | Observação |
|------|----------|------------|
| Module | Módulo funcional | Agrupamento lógico de capabilities |
| Capability | Capacidade operacional | Funcionalidade executável |
| Resource | Recurso compartilhado | Dados, serviços, integrações |
| Service | Serviço técnico | APIs, workers, schedulers |
| Integration | Integração externa | Sistemas, APIs terceiras, webhooks |
| Workflow | Fluxo automatizado | N8N, processos, orquestrações |
| Tool | Ferramenta operacional | Utilitários, assistentes, validadores |

---

## 3. Boundaries

### 3.1 Registry É

- O catálogo central da plataforma.
- A fonte de verdade estrutural dos elementos canônicos.
- O organizador de referências entre módulos, capabilities, recursos e integrações.
- A base para Discovery.
- O mecanismo de identificação única de elementos.
- O repositório de metadados canônicos.

### 3.2 Registry NÃO é

- ❌ **Authorization**: não decide permissão.
- ❌ **Discovery**: não resolve contexto.
- ❌ **Menu**: não projeta interface de navegação.
- ❌ **Capability**: não representa uma capacidade executável.
- ❌ **Runtime**: não executa operação.
- ❌ **Configuração de produto**: não carrega parâmetros operacionais de módulo.
- ❌ **Frontend**: não exibe nada.
- ❌ **Cache**: é a fonte, não um derivado.

### 3.3 Limites claros

```text
REGISTRY
  │
  ├── É responsável por: catálogo, identificação, metadados, organização estrutural
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── descoberta contextual (Discovery)
        ├── execução (Runtime)
        ├── capacidade individual (Capability)
        ├── navegação (Navigation)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Manter o catálogo central de todos os elementos registráveis da plataforma.
4.2 Garantir identificação única canônica para cada elemento.
4.3 Armazenar metadados obrigatórios de cada elemento.
4.4 Permitir consulta estruturada do catálogo.
4.5 Suportar versionamento de elementos.
4.6 Gerenciar ciclo de vida estrutural (criação, publicação, depreciação, arquivamento).
4.7 Servir como fonte para Discovery.
4.8 Garantir que nenhum elemento entre na plataforma sem registro.
4.9 Manter histórico de alterações estruturais.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Administração da Plataforma | Publica e gerencia elementos estruturais |
| Desenvolvedor de Capability | Registra nova capability no Registry |
| Integrador | Registra novas integrações |
| Administração do Tenant | Habilita/desabilita elementos por tenant |
| IA | Analisa catálogo para sugerir otimizações estruturais (não decide) |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Discovery | Consulta Registry para filtrar capabilities por contexto |
| Capability | É registrada e referenciada pelo Registry |
| Runtime | Consulta Registry para validar existência de capabilities |
| Navigation | Usa Registry como base para projeção de menu |
| Integration | Consulta Registry para descobrir integrações disponíveis |
| Workflow | Consulta Registry para workflows registrados |
| Authorization | Consulta Registry para identificar recursos e operações |
| Portal | Consulta Registry para montar workspace |
| IA | Consulta Registry para entender a estrutura da plataforma |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Registry
  │
  ├── Module (agrupamento lógico)
  │     └── 1:N → Capability
  │
  ├── Capability (capacidade individual)
  │     ├── 1:N → Resource
  │     ├── 1:N → Service
  │     └── 1:N → Integration
  │
  ├── Resource (recurso compartilhado)
  │
  ├── Service (serviço técnico)
  │
  ├── Integration (integração externa)
  │
  ├── Workflow (fluxo automatizado)
  │
  └── Tool (ferramenta operacional)
```

### 7.2 Modelo conceitual

```text
Registry (catálogo central)
  │
  ├── Module: Assistencial
  │     ├── Capability: Prontuário Eletrônico
  │     ├── Capability: Prescrição Digital
  │     └── Capability: Evolução Clínica
  │
  ├── Module: Administrativo
  │     ├── Capability: Agenda
  │     └── Capability: Faturamento
  │
  ├── Integration: TASY
  │     └── Service: TASY-API
  │
  ├── Workflow: Triagem Automática
  │
  └── Tool: Calculadora de Risco
```

### 7.3 Registry como fonte de verdade

```text
Registry é a fonte.
Discovery é a projeção contextual.
Navigation é a projeção de interface.

Se Registry diz que existe,
  Discovery pode descobrir,
  Navigation pode projetar,
  Runtime pode executar.

Se Registry diz que não existe,
  nenhuma camada acima pode inventar.
```

### 7.4 Separação de conceitos

```text
REGISTRY
  │
  ├── NÃO é Menu
  │     └── Menu é projeção de Registry + Discovery + Authorization
  │
  ├── NÃO é Permissão
  │     └── Permissão é regra aplicada sobre Registry
  │
  ├── NÃO é Contexto
  │     └── Contexto é estado operacional momentâneo
  │
  ├── NÃO é Authorization
  │     └── Authorization decide acesso; Registry apenas lista
  │
  ├── NÃO é Discovery
  │     └── Discovery filtra Registry por contexto; Registry é o catálogo completo
  │
  └── NÃO é Configuração
        └── Configuração é parâmetro de módulo; Registry é estrutura
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Kernel Platform Definition | Registry é definido pela arquitetura da plataforma |
| Discovery | Discovery consome Registry para filtrar capabilities |

### 8.2 É dependido por

| Domínio | Como depende de Registry |
|---------|---------------------------|
| Discovery | Discovery consulta Registry para filtrar capabilities |
| Capability | Capability é registrada e referenciada no Registry |
| Runtime | Runtime valida existência de capabilities no Registry |
| Navigation | Navigation usa Registry como base estrutural |
| Authorization | Authorization consulta Registry para identificar recursos |
| Workflow | Workflow é registrado no Registry |
| Integration | Integration é registrada no Registry |
| Portal | Portal consulta Registry para montar workspace |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- |
| Identity     | —        |        |         |         |               |           |          |
| Tenant       |          | —      |         |         |               |           |          |
| Session      | ✔        | ✔      | —       |         |               |           |          |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |          |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |          |
| Registry     |          |        |         |         |               | ✔         | —        |
| Capability   |          |        |         |         |               | ✔         | ✔        |
| Runtime      |          |        |         |         |               | ✔         | ✔        |
| Navigation   |          |        |         |         |               | ✔         | ✔        |
| Workflow     |          |        |         |         |               | ✔         | ✔        |
| Event        |          |        |         |         |               | ✔         | ✔        |
| Ledger       |          |        |         |         |               | ✔         | ✔        |
| Integration  |          |        |         |         |               | ✔         | ✔        |

---

## 9. Estados Canônicos

### 9.1 Estados de elemento no Registry

| Estado | Descrição |
|--------|-----------|
| DRAFT | Elemento em criação, não visível para descoberta |
| PUBLISHED | Elemento publicado e disponível para descoberta |
| DEPRECATED | Elemento em depreciação, ainda visível mas com aviso |
| ARCHIVED | Elemento arquivado, não disponível para descoberta |
| REMOVED | Elemento removido do catálogo, mantido para histórico |

### 9.2 Regras de transição

```text
DRAFT → PUBLISHED (elemento aprovado e publicado)
PUBLISHED → DEPRECATED (elemento marcado para remoção futura)
DEPRECATED → ARCHIVED (elemento arquivado após período de depreciação)
DEPRECATED → PUBLISHED (elemento reativado durante depreciação)
ARCHIVED → REMOVED (elemento removido após retenção)
```

### 9.3 Regras de negócio

- Todo elemento deve ter identificação única canônica antes de ser publicado.
- Todo elemento publicado deve ter metadados obrigatórios completos.
- Elemento DEPRECATED continua disponível para Discovery, mas com indicação de depreciação.
- Elemento ARCHIVED não é descoberto por Discovery.
- Elemento REMOVED é mantido para histórico, mas não é mais referenciável.
- Toda transição de estado de Registry deve gerar evento no Ledger.
- Registry não pode ter elementos duplicados por identificação canônica.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Registry é o primeiro domínio da **Runtime Layer**.

É a base estrutural que conecta a governança (Authorization) à execução (Runtime).

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
```

### 10.2 Contratos

Registry não é uma SP. Registry é um conceito.

Sua materialização será:
- Tabelas: `registry_module`, `registry_capability`, `registry_integration`, `registry_workflow`, `registry_tool`, etc.
- SPs: `sp_registry_publish`, `sp_registry_get`, `sp_registry_deprecate`, `sp_registry_list`, etc.
- Views: `vw_registry_published`, `vw_registry_by_type`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Registry é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Registry referencia identities quando necessário |
| Tenant | Registry opera dentro de um tenant |
| Session | Registry consultado no contexto de uma sessão |
| Context | Registry é independente de contexto |
| Authorization | Authorization consulta Registry para identificar recursos |
| Discovery | Discovery filtra o catálogo do Registry |
| Capability | Capability é registrada no Registry |
| Runtime | Runtime valida existência de capabilities no Registry |
| Navigation | Navigation usa Registry como base estrutural |
| Workflow | Workflow é registrado no Registry |
| Event | Evento registra alterações no Registry |
| Ledger | Ledger persiste histórico de alterações do Registry |
| Integration | Integration é registrada no Registry |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza o catálogo da plataforma em um ponto único.
- Elimina duplicação de referências de módulos e capabilities.
- Torna a descoberta consistente e confiável.
- Suporta evolução de capabilities sem alterar produtos consumidores.
- Cria base para governança de módulos e integrações.
- Permite auditoria completa de alterações estruturais.
- Separa claramente estrutura de execução.

### 11.2 Impactos negativos / Riscos

- Complexidade de governança:Registry sem dono fica desorganizado.
- Performance: consultas ao Registry são frequentes em toda plataforma.
- Migração: elementos legados precisam ser mapeados para o Registry.
- Versionamento: alterações em capabilities podem quebrar consumidores.
- Dependência única: se Registry falha, toda descoberta falha.

### 11.3 Mitigações

- Política de metadados obrigatórios para toda publicação.
- Indexação otimizada para consultas frequentes.
- Versionamento semântico de capabilities.
- Cache de Registry com invalidação controlada.
- Dashboard de health e governança do Registry.
- Processo de aprovação para publicação de elementos.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de registry será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de registry será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de registry deve estar coerente com as SPs que a consomem.
12.4 Todo índice de registry deve suportar as consultas mais frequentes (busca por tipo, status, tenant, capability).
12.5 Nenhum elemento pode ser descoberto sem estar registrado no Registry.
12.6 Toda alteração de estado de Registry deve gerar evento no Ledger.
12.7 Registry é fonte de verdade; nenhuma camada acima pode alterar sua estrutura diretamente.
12.8 A materialização depende da aprovação do MD-KERNEL-007 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MD-KERNEL-004 — Context
- MD-KERNEL-005 — Authorization
- MD-KERNEL-006 — Discovery
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
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-007 — Registry |

---

Documento Canônico — MD-KERNEL-007

**Este é o sétimo domínio do Kernel Enterprise. Pertence à Runtime Layer e é pré-requisito para Discovery, Capability, Runtime, Navigation e Integration.**
