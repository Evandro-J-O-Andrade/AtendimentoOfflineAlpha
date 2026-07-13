# MAP-CORE-PLATFORM

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Artefato de transição para materialização.
```

---

## 1. Propósito

Este documento apresenta o **Core Platform** da plataforma New Wave Enterprise.

Ele serve para:
- Relacionar o Kernel com a camada executável da plataforma
- Definir os módulos estruturais que todo produto consumidor utiliza
- Evitar duplicação de núcleo entre produtos
- Estabelecer o caminho de materialização Kernel → Core → Produtos

---

## 2. Posicionamento Arquitetural

```text
Kernel Enterprise
      ↓
Core Platform
      ↓
Produtos Consumidores
```

O Core Platform é a **primeira camada executável** acima do Kernel.
Ela não é um produto.
Ela é a **base comum** que todos os produtos compartilham.

```text
Kernel
  ├── Foundation
  ├── Governance
  ├── Runtime
  └── Integration
        ↓
Core Platform
  ├── Auth Runtime
  ├── Context Runtime
  ├── Portal Runtime
  ├── Navigation Runtime
  ├── Integration Runtime
  ├── Workflow Runtime
  ├── Event Runtime
  ├── Ledger Runtime
  └── Runtime Core
        ↓
Produtos
  ├── HIS
  ├── ERP
  ├── CRM
  ├── BI
  ├── Mobile
  ├── Display
  └── Marketplace
```

---

## 3. Domínios do Core Platform

### 3.1 Visão geral

| Domínio | Natureza | Responsabilidade |
|---------|----------|------------------|
| Auth Runtime | Execução | Autenticação e sessão |
| Context Runtime | Execução | Resolução de contexto operacional |
| Portal Runtime | Execução | Launcher e workspace |
| Navigation Runtime | Execução | Projeção de navegação |
| Integration Runtime | Execução | Conexão externa |
| Workflow Runtime | Execução | Orquestração de processos |
| Event Runtime | Execução | Publicação e consumo de eventos |
| Ledger Runtime | Execução | Registro de evidências |
| Runtime Core | Execução | Coordenação geral |

### 3.2 Domínio: Auth Runtime

Responsável por:
- Autenticação de identidades
- Criação e validação de sessões
- Aplicação de políticas de senha e MFA
- Revogação de sessões
- Emissão e validação de tokens

Consumidores:
- Todos os produtos
- APIs externas
- Dispositivos

Depende de:
- Kernel: Identity, Session, Authorization

### 3.3 Domínio: Context Runtime

Responsável por:
- Resolução de contexto operacional
- Seleção de unidade, local, perfil
- Troca de contexto
- Snapshots de contexto
- Validação de transições

Consumidores:
- Todos os produtos
- Runtime
- Navigation

Depende de:
- Kernel: Identity, Tenant, Session, Context

### 3.4 Domínio: Portal Runtime

Responsável por:
- Launcher de aplicações
- Seleção de contexto
- Workspace unificado
- App Registry
- Navegação inicial

Consumidores:
- Portal Enterprise
- Intranet
- Mobile

Depende de:
- Kernel: Identity, Session, Context, Discovery, Navigation
- Core: Auth Runtime, Context Runtime

### 3.5 Domínio: Navigation Runtime

Responsável por:
- Projeção de menus
- Projeção de dashboards
- Projeção de ações
- Adaptação por dispositivo
- Acessibilidade

Consumidores:
- Portal
- Mobile
- Display
- Totem
- APIs

Depende de:
- Kernel: Discovery, Capability, Runtime, Navigation
- Core: Portal Runtime

### 3.6 Domínio: Integration Runtime

Responsável por:
- APIs externas
- Webhooks
- Mensageria
- ETL
- Transformação de dados

Consumidores:
- Sistemas externos
- HIS
- ERP
- CRM
- BI
- Parceiros

Depende de:
- Kernel: Integration, Event, Ledger, Authorization
- Core: Auth Runtime, Context Runtime

### 3.7 Domínio: Workflow Runtime

Responsável por:
- Execução de workflows
- Orquestração de etapas
- Compensação
- Timeout e retry
- Estado de processos

Consumidores:
- Todos os produtos
- Automação
- IA

Depende de:
- Kernel: Workflow, Event, Ledger, Runtime
- Core: Auth Runtime, Context Runtime

### 3.8 Domínio: Event Runtime

Responsável por:
- Publicação de eventos
- Consumo de eventos
- Roteamento de eventos
- Retry e dead letter
- Correlation ID

Consumidores:
- Todos os produtos
- Integrações externas
- Analytics
- IA

Depende de:
- Kernel: Event, Ledger

### 3.9 Domínio: Ledger Runtime

Responsável por:
- Registro de evidências
- Consulta histórica
- Arquivo e purga
- Auditoria
- Compliance

Consumidores:
- Auditoria
- Compliance
- BI
- Suporte
- IA

Depende de:
- Kernel: Ledger, Event

### 3.10 Domínio: Runtime Core

Responsável por:
- Coordenação geral
- Resiliência
- Cache
- Sync
- Filas e jobs

Consumidores:
- Todos os domínios do Core
- Todos os produtos

Depende de:
- Kernel: Runtime
- Core: Auth Runtime, Context Runtime

---

## 4. Relacionamentos

### 4.1 Visão geral

```text
Core Platform
  │
  ├── Auth Runtime
  │     └── Depende de: Identity, Session, Authorization
  │
  ├── Context Runtime
  │     └── Depende de: Identity, Tenant, Session, Context
  │
  ├── Portal Runtime
  │     └── Depende de: Discovery, Navigation, Capability
  │
  ├── Navigation Runtime
  │     └── Depende de: Discovery, Capability, Runtime
  │
  ├── Integration Runtime
  │     └── Depende de: Integration, Event, Ledger, Authorization
  │
  ├── Workflow Runtime
  │     └── Depende de: Workflow, Event, Ledger, Runtime
  │
  ├── Event Runtime
  │     └── Depende de: Event, Ledger
  │
  ├── Ledger Runtime
  │     └── Depende de: Ledger
  │
  └── Runtime Core
        └── Depende de: Runtime
```

### 4.2 Fluxo de dependência

```text
Kernel
  ↓
Core Platform
  ├── Auth Runtime
  ├── Context Runtime
  ├── Portal Runtime
  ├── Navigation Runtime
  ├── Integration Runtime
  ├── Workflow Runtime
  ├── Event Runtime
  ├── Ledger Runtime
  └── Runtime Core
        ↓
Produtos Consumidores
```

### 4.3 Separação de conceitos

```text
CORE PLATFORM
  │
  ├── NÃO é Produto
  │     └── Produto consome Core; Core não é produto
  │
  ├── NÃO é Kernel
  │     └── Kernel é conceitual; Core é executável
  │
  ├── NÃO é Frontend
  │     └── Frontend consome Core; Core não é interface
  │
  ├── NÃO é Banco
  │     └── Banco é persistência; Core é execução
  │
  └── NÃO é API
        └── API é contrato; Core é implementação
```

---

## 5. Cobertura por Produto

### 5.1 Matriz de cobertura

| Produto           | Auth Runtime | Context Runtime | Portal Runtime | Navigation Runtime | Integration Runtime | Workflow Runtime | Event Runtime | Ledger Runtime | Runtime Core |
| ----------------- | ------------ | --------------- | -------------- | ------------------ | ------------------- | ---------------- | ------------- | -------------- | ------------ |
| HIS               | ✅           | ✅              | ✅             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| Portal Enterprise | ✅           | ✅              | ✅             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| Intranet          | ✅           | ✅              | ✅             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| ERP               | ✅           | ✅              | ❌             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| CRM               | ✅           | ✅              | ❌             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| BI                | ❌           | ❌              | ❌             | ❌                 | ✅                  | ❌               | ✅            | ✅             | ✅           |
| Mobile            | ✅           | ✅              | ✅             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| Display/TV        | ❌           | ❌              | ❌             | ✅                 | ❌                  | ❌               | ❌            | ❌             | ✅           |
| API Gateway       | ✅           | ✅              | ❌             | ❌                 | ✅                  | ✅               | ✅            | ✅             | ✅           |
| Marketplace       | ✅           | ✅              | ✅             | ✅                 | ✅                  | ✅               | ✅            | ✅             | ✅           |

### 5.2 Análise de cobertura

- **HIS**: consome todo o Core Platform
- **Portal Enterprise**: consome todo o Core Platform
- **Intranet**: consome todo o Core Platform
- **ERP**: consome majoritariamente o Core Platform
- **CRM**: consome majoritariamente o Core Platform
- **BI**: consome Event, Ledger e Integration
- **Mobile**: consome todo o Core Platform
- **Display/TV**: consome Navigation e Runtime Core
- **API Gateway**: consome Auth, Context, Integration, Workflow, Event, Ledger
- **Marketplace**: consome todo o Core Platform

---

## 6. Fluxo de Materialização

```text
Kernel (conceitual)
  ↓
Core Platform (executável)
  ↓
Produtos (consumidores)
```

### 6.1 Fases

| Fase | Artefato | Descrição |
|------|----------|-----------|
| 1 | Kernel MDs | Documentos conceituais aprovados |
| 2 | Core Maps | MAP-CORE-PLATFORM, MAP-RUNTIME-FLOW, MAP-DATA |
| 3 | BR Catalog | Regras de negócio centralizadas |
| 4 | Front Catalog | FRONT-CATALOG |
| 5 | Modelo Lógico | Entidades e relacionamentos |
| 6 | Modelo Físico | Tabelas, índices, constraints |
| 7 | SQL | Scripts de criação |
| 8 | SP Catalog | Catálogo de procedures |
| 9 | Backend | Implementação Node.js |
| 10 | Frontend | Implementação React |

### 6.2 Ordem de execução

```text
FASE 1 — Documentação
  ├── Kernel MDs ✅
  ├── Core Maps ⏳
  ├── BR Catalog ⏳
  └── Front Catalog ⏳

FASE 2 — Revisão Transversal
  └── Validar produtos contra Kernel + Core

FASE 3 — Modelagem
  ├── Modelo Lógico
  ├── Modelo Físico
  └── SQL

FASE 4 — Implementação
  ├── SP Catalog
  ├── Backend
  └── Frontend
```

---

## 7. Regras de Governança

### 7.1 Núcleo comum

```text
Todo produto deve consumir o Core Platform.
Nenhum produto pode criar seu próprio núcleo.
Nenhum produto pode duplicar Auth, Context, Portal, Navigation, Integration, Workflow, Event, Ledger, Runtime Core.
```

### 7.2 Evolução

```text
Novo domínio no Core Platform:
1. Verificar se já existe no Kernel
2. Se não existir: criar MD-KERNEL-XXX primeiro
3. Depois: materializar no Core Platform
4. Depois: expor para produtos
```

### 7.3 Isolamento

```text
Produto não pode acessar Kernel diretamente.
Produto deve consumir Core Platform.
Core Platform isola produto do Kernel.
```

---

## 8. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 9. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do mapa do Core Platform |

---

Documento Canônico — MAP-CORE-PLATFORM

**Este é o documento oficial do Core Platform. Ele relaciona o Kernel com a camada executável compartilhada por todos os produtos.**
