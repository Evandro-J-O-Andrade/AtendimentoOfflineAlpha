# MD-KERNEL-008 — Capability

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Runtime Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-007 — Registry
Consumido por: MD-KERNEL-009 — Runtime
Consumido por: MD-KERNEL-010 — Navigation
```

---

## 1. Objetivo

Definir o conceito canônico de **Capability** no Kernel Enterprise.

Capability é a camada responsável por responder:

> **"O que a plataforma sabe fazer?"**

Ela não é uma tela.
Ela não é um menu.
Ela não é uma permissão.
Ela é a **unidade funcional reutilizável** que representa uma capacidade operacional da plataforma, independente de produto, interface ou contexto.

Sem Capability, o Registry tem estrutura, mas não tem significado operacional.
Sem Registry, a Capability não tem referência canônica.

---

## 2. Definição Canônica

```text
Capability representa uma unidade funcional reutilizável
da plataforma New Wave Enterprise.

Capability é:
  - uma capacidade operacional
  - uma unidade de composição
  - um elemento registrado no Registry
  - independente de produto
  - independente de interface
  - independente de contexto
  - base para Runtime, Discovery e Navigation

Capability não responde:
  "quem pode acessar?"
  "onde está cadastrado?"
  "como aparece para o usuário?"
  "como executar?"

Capability responde apenas:
  "o que a plataforma consegue fazer?"
```

### 2.1 Princípio fundamental

```text
Capability é o significado operacional da plataforma.
Registry é a estrutura.
Discovery é a disponibilidade.
Runtime é a execução.
Navigation é a apresentação.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Reutilizável | Capability pode ser usada por múltiplos produtos |
| Composta | Capability pode agregar outras capabilities |
| Registrada | Toda Capability está registrada no Registry |
| Identificada | Toda Capability tem identificação única canônica |
| Independente | Não depende de produto, interface ou contexto |
| Executável | Capability representa ação operacional realizável |
| Composta | Capability pode ser composta por sub-capabilities |
| Auditável | Toda alteração de Capability é registrada |

### 2.3 Tipos de Capability

| Tipo | Natureza | Observação |
|------|----------|------------|
| Assistencial | Capacidade clínica ou assistencial | Ex: Atender paciente, Dispensar medicamento |
| Administrativa | Capacidade administrativa | Ex: Gerenciar agenda, Processar faturamento |
| Técnica | Capacidade técnica ou de infraestrutura | Ex: Sincronizar dados, Exportar relatório |
| Integração | Capacidade que conecta sistemas externos | Ex: Consultar TASY, Enviar para cartório |
| Automação | Capacidade executada automaticamente | Ex: Triagem automática, Alerta de estoque |
| IA | Capacidade executada por inteligência artificial | Ex: Sugestão de diagnóstico, Classificação de risco |
| Utility | Capacidade utilitária transversal | Ex: Calculadora de idade, Validador de CPF |

---

## 3. Boundaries

### 3.1 Capability É

- A unidade funcional reutilizável da plataforma.
- O significado operacional do que a plataforma sabe fazer.
- O elemento composto por recursos, regras e interfaces.
- A referência para Discovery e Runtime.
- A base para composição de produtos.
- O elemento que agrega valor operacional ao Registry.

### 3.2 Capability NÃO é

- ❌ **Tela**: não representa interface de usuário.
- ❌ **Menu**: não representa navegação.
- ❌ **Permissão**: não define acesso.
- ❌ **Role / Perfil**: não representa papel organizacional.
- ❌ **Workflow específico**: não representa fluxo pontual.
- ❌ **Implementação técnica**: não define como executar.
- ❌ **Produto**: não representa aplicação final.
- ❌ **Configuração**: não carrega parâmetros operacionais de tenant.
- ❌ **Recurso isolado**: não é apenas um dado ou serviço.

### 3.3 Limites claros

```text
CAPABILITY
  │
  ├── É responsável por: capacidade funcional, composição, reuso operacional
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── catálogo estrutural (Registry)
        ├── descoberta contextual (Discovery)
        ├── execução (Runtime)
        ├── navegação (Navigation)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Representar capacidades funcionais reutilizáveis da plataforma.
4.2 Agrupar elementos relacionados em unidades coesas de valor operacional.
4.3 Ser referenciada por Registry para identificação canônica.
4.4 Ser descoberta por Discovery no contexto correto.
4.5 Ser autorizada por Authorization antes da execução.
4.6 Ser executada por Runtime quando autorizada.
4.7 Ser projetada por Navigation quando disponível.
4.8 Suportar composição: Capability pode conter sub-capabilities.
4.9 Manter ciclo de vida: criação, publicação, depreciação, arquivamento.
4.10 Garantir que nenhuma funcionalidade entre na plataforma sem Capability registrada.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Arquitetura da Plataforma | Define capabilities estruturais da plataforma |
| Desenvolvedor de Produto | Registra novas capabilities no Registry |
| Administração do Tenant | Habilita/desabilita capabilities por tenant |
| IA | Analisa padrões de uso para sugerir novas capabilities (não decide) |
| Integrador | Registra capabilities de integração externa |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Registry | Armazena e referencia Capability |
| Discovery | Descobre Capability disponível no contexto |
| Authorization | Valida acesso a Capability |
| Runtime | Executa Capability autorizada |
| Navigation | Projeta Capability como item de menu ou ação |
| Workflow | Compõe fluxos usando Capabilities |
| Integration | Expõe Capability para sistemas externos |
| Portal | Apresenta Capability no workspace do usuário |
| IA | Consulta Capability para sugerir ações ao usuário |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Capability
  │
  ├── Registry (referência canônica)
  │
  ├── 1:N → Sub-Capability (composição)
  │
  ├── 1:N → Resource (recursos necessários)
  │
  ├── 1:N → Service (serviços que executa)
  │
  ├── 1:N → Integration (integrações que utiliza)
  │
  ├── 1:N → Authorization (permissões aplicáveis)
  │
  ├── 1:N → Runtime (execuções possíveis)
  │
  └── 1:N → Event (eventos gerados)
```

### 7.2 Modelo conceitual

```text
Registry (catálogo)
  │
  └── Capability: Atender Paciente
        │
        ├── Sub-Capability: Registrar triagem
        ├── Sub-Capability: Abrir prontuário
        ├── Sub-Capability: Solicitar exame
        │
        ├── Resource: Prontuário eletrônico
        ├── Resource: Fila de atendimento
        │
        ├── Service: Notificação de chamada
        ├── Service: Impressão de senha
        │
        └── Integration: TASY (consulta de histórico)
```

### 7.3 Capability como conceito, não como implementação

```text
CAPABILITY
  │
  ├── É: "Atender paciente"
  │     └── Conceito operacional reutilizável
  │
  ├── NÃO É: "Tela de atendimento"
  │     └── Isso é projeção de Navigation
  │
  ├── NÃO É: "Botão abrir atendimento"
  │     └── Isso é elemento de interface
  │
  ├── NÃO É: "Permissão de atendimento"
  │     └── Isso é decisão de Authorization
  │
  ├── NÃO É: "Procedure sp_atendimento_abrir"
  │     └── Isso é implementação de Runtime
  │
  └── NÃO É: "Módulo HIS"
        └── Isso é produto consumidor
```

### 7.4 Separação de conceitos

```text
CAPABILITY
  │
  ├── NÃO é Tela
  │     └── Tela é projeção de Navigation
  │
  ├── NÃO é Menu
  │     └── Menu é projeção de Navigation
  │
  ├── NÃO é Permissão
  │     └── Permissão é regra de Authorization
  │
  ├── NÃO é Workflow
  │     └── Workflow é orquestração de capabilities
  │
  ├── NÃO é Implementação
  │     └── Implementação é detalhe de Runtime
  │
  ├── NÃO é Configuração
  │     └── Configuração é parâmetro de tenant
  │
  └── NÃO é Produto
        └── Produto é composição de capabilities
```

### 7.5 Composição de Capability

```text
Capability: Atendimento Completo
  │
  ├── Sub-Capability: Triagem
  ├── Sub-Capability: Consulta médica
  ├── Sub-Capability: Prescrição
  ├── Sub-Capability: Exames
  └── Sub-Capability: Encerramento
```

Capability pode ser composta por outras capabilities.
Isso permite reuso e composição de produtos.

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Registry | Capability está registrada no Registry |

### 8.2 É dependido por

| Domínio | Como depende de Capability |
|---------|----------------------------|
| Registry | Registry armazena Capability |
| Discovery | Discovery descobre Capability disponível |
| Authorization | Authorization valida acesso a Capability |
| Runtime | Runtime executa Capability autorizada |
| Navigation | Navigation projeta Capability como item navegável |
| Workflow | Workflow compõe fluxos com Capabilities |
| Integration | Integration expõe Capability externamente |
| Portal | Portal apresenta Capability no workspace |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- | ---------- |
| Identity     | —        |        |         |         |               |           |          |            |
| Tenant       |          | —      |         |         |               |           |          |            |
| Session      | ✔        | ✔      | —       |         |               |           |          |            |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |            |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |          |            |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |          |            |
| Registry     |          |        |         |         |               | ✔         | —        |            |
| Capability   |          |        |         |         |               | ✔         | ✔        | —          |
| Runtime      |          |        |         |         |               | ✔         | ✔        | ✔          |
| Navigation   |          |        |         |         |               | ✔         | ✔        | ✔          |
| Workflow     |          |        |         |         |               | ✔         | ✔        | ✔          |
| Event        |          |        |         |         |               | ✔         | ✔        | ✔          |
| Ledger       |          |        |         |         |               | ✔         | ✔        | ✔          |
| Integration  |          |        |         |         |               | ✔         | ✔        | ✔          |

---

## 9. Estados Canônicos

### 9.1 Estados de Capability

| Estado | Descrição |
|--------|-----------|
| DRAFT | Capability em criação, não disponível |
| PUBLISHED | Capability publicada e disponível para descoberta |
| DEPRECATED | Capability em depreciação, ainda disponível com aviso |
| ARCHIVED | Capability arquivada, não disponível |
| REMOVED | Capability removida, mantida para histórico |
| COMPOSED | Capability que é composição de outras capabilities |

### 9.2 Regras de transição

```text
DRAFT → PUBLISHED (aprovada e publicada)
PUBLISHED → DEPRECATED (marcada para remoção futura)
DEPRECATED → PUBLISHED (reativada durante depreciação)
DEPRECATED → ARCHIVED (arquivada após período de depreciação)
ARCHIVED → REMOVED (removida após retenção)
PUBLISHED → COMPOSED (transformada em composição)
COMPOSED → PUBLISHED (desfeita composição)
```

### 9.3 Regras de negócio

- Toda Capability deve estar registrada no Registry antes de ser publicada.
- Capability PUBLISHED pode ser descoberta por Discovery.
- Capability DEPRECATED continua descoberta, mas com indicação de depreciação.
- Capability ARCHIVED não é descoberta por Discovery.
- Capability COMPOSED não é executável diretamente; apenas suas sub-capabilities são.
- Toda transição de estado de Capability deve gerar evento no Ledger.
- Capability não pode ser duplicada por identificação canônica no Registry.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Capability é o elemento central da **Runtime Layer**.

É a unidade de valor operacional que conecta Registry, Discovery, Authorization e Runtime.

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

Capability não é uma SP. Capability é um conceito.

Sua materialização será:
- Tabelas: `capability_registry`, `capability_composition`, `capability_metadata`, etc.
- SPs: `sp_capability_create`, `sp_capability_publish`, `sp_capability_compose`, `sp_capability_get`, etc.
- Views: `vw_capability_published`, `vw_capability_composition`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Capability é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Capability é atribuída ou descoberta para uma identity |
| Tenant | Capability opera dentro de um tenant |
| Session | Capability é descoberta no contexto de uma sessão |
| Context | Capability é resolvida no contexto operacional |
| Authorization | Capability é autorizada para identidade/contexto |
| Discovery | Discovery descobre Capability disponível |
| Registry | Capability está registrada no Registry |
| Runtime | Runtime executa Capability autorizada |
| Navigation | Navigation projeta Capability como item navegável |
| Workflow | Workflow compõe fluxos com Capabilities |
| Event | Evento registra execuções de Capability |
| Ledger | Ledger persiste histórico de Capability |
| Integration | Integration expõe Capability para sistemas externos |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza o significado operacional da plataforma.
- Permite composição de produtos por capabilities.
- Torna a descoberta e execução consistentes.
- Suporta multi-tenant e multi-produto naturalmente.
- Cria base para governança de funcionalidades.
- Permite evolução de capabilities sem alterar produtos consumidores.
- Separa claramente "o que a plataforma faz" de "como executar".

### 11.2 Impactos negativos / Riscos

- Complexidade de modelagem: capabilities podem ser muito granulares ou muito amplas.
- Performance: composição de capabilities pode ser custosa.
- Migração: funcionalidades legadas precisam ser mapeadas para capabilities.
- Governança: capabilities sem dono poluem o catálogo.
- Dependência cíclica: cuidado para não criar ciclo Registry ↔ Capability.

### 11.3 Mitigações

- Padrões de modelagem de capability documentados.
- Limites de profundidade de composição.
- Metadados obrigatórios e dono definido para toda Capability.
- Dashboard de governança de capabilities por tenant.
- Testes de composição e descoberta automatizados.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de capability será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de capability será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de capability deve estar coerente com as SPs que a consomem.
12.4 Todo índice de capability deve suportar as consultas mais frequentes (busca por registry, tipo, tenant, contexto).
12.5 Nenhuma funcionalidade pode existir na plataforma sem Capability registrada.
12.6 Toda alteração de estado de Capability deve gerar evento no Ledger.
12.7 Capability não pode conter regra de negócio; apenas estrutura operacional.
12.8 Capability não pode ser duplicada no Registry por identificação canônica.
12.9 A materialização depende da aprovação do MD-KERNEL-008 e do dossiê correspondente.

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
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-008 — Capability |

---

Documento Canônico — MD-KERNEL-008

**Este é o oitavo domínio do Kernel Enterprise. Pertence à Runtime Layer, depende de Registry e é pré-requisito para Runtime e Navigation.**
