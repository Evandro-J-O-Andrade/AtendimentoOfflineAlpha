# MD-KERNEL-002 — Tenant

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Foundation Layer
Pré-requisito: MD-KERNEL-001 — Identity
```

---

## 1. Objetivo

Definir o conceito canônico de **Tenant** no Kernel Enterprise.

Tenant é a camada responsável por responder:

> **"Em qual organização isolada esta identidade opera?"**

Ele não é usuário.
Ele não é empresa física obrigatoriamente.
Ele é o **contexto organizacional de isolamento do Kernel**.

---

## 2. Definição Canônica

```text
Tenant representa a fronteira organizacional isolada
dentro da plataforma New Wave Enterprise.

Ele define:
  - quem é dono dos dados;
  - qual organização utiliza a plataforma;
  - quais recursos pertencem àquela organização;
  - quais regras de isolamento devem ser aplicadas.

Tenant é a raiz de governança organizacional.
Tenant é a unidade lógica de isolamento.
Tenant é independente de identidade.
```

### 2.1 Princípio fundamental

```text
Identity existe primeiro.

Tenant define onde a Identity atua.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Isolamento | Dados de um Tenant não são visíveis por outro Tenant |
| Governança | Tenant define proprietários, administradores e políticas |
| Configuração | Cada Tenant possui módulos, parâmetros e integrações próprias |
| Ciclo de vida | Tenant tem estados claros: CREATED, CONFIGURING, ACTIVE, SUSPENDED, DISABLED, ARCHIVED |
| Multi-identidade | Um Tenant pode conter múltiplas identities (pessoas, usuários, serviços) |

---

## 3. Boundaries

### 3.1 Tenant É

- Unidade lógica de isolamento.
- Raiz de governança organizacional.
- Dono de configurações próprias.
- Controlador de escopo operacional.

### 3.2 Tenant NÃO é

- ❌ **Pessoa**: não representa um indivíduo.
- ❌ **Usuário**: não representa uma credencial de acesso.
- ❌ **Permissão**: não define o que pode ser feito.
- ❌ **Contexto operacional**: não carrega unidade, local ou perfil.
- ❌ **Sessão**: não representa uma sessão ativa.
- ❌ **Módulo**: não é uma capability ou sistema.
- ❌ **Empresa física obrigatoriamente**: pode ser uma organização, departamento, projeto ou entidade.

### 3.3 Limites claros

```text
TENANT
  │
  ├── É responsável por: isolamento, governança, configuração, ciclo de vida
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── autenticação (Auth)
        ├── sessão (Session)
        ├── contexto operacional (Context)
        ├── permissões (Authorization)
        ├── execução (Runtime)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Garantir isolamento de dados entre organizações.
4.2 Definir configurações próprias (módulos, parâmetros, integrações, regras).
4.3 Controlar ciclo de vida (criação, configuração, ativação, suspensão, desativação, arquivamento).
4.4 Ser a raiz de governança organizacional.
4.5 Permitir múltiplas identities dentro de seu escopo.
4.6 Ser o escopo de todas as operações do Kernel.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Provisionamento SaaS | Cria tenants automaticamente durante onboarding |
| Administração da Plataforma | Cria e gerencia tenants manualmente |
| Processos autorizados | Integrações externas podem solicitar criação via API autorizada |
| IA | Agentes não criam tenants; apenas consomem |

---

## 6. Consumidores

| Consumidor | Como usa |
|-------------|----------|
| Identity | Identity pode pertencer a múltiplos tenants |
| Session | Sessão é sempre vinculada a um tenant |
| Context | Contexto é resolvido dentro de um tenant |
| Authorization | Permissões são validadas dentro de um tenant |
| Discovery | Discovery resolve capabilities por tenant |
| Registry | Registry filtra por tenant |
| Capability | Capability é habilitada por tenant |
| Runtime | Runtime opera dentro de um tenant |
| Navigation | Navigation projeta menu por tenant |
| Workflow | Workflow é executado dentro de um tenant |
| Event | Evento é registrado por tenant |
| Ledger | Ledger registra por tenant |
| Integration | Integration autentica por tenant |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Tenant
  │
  ├── 1:N → Identity (pessoas, usuários, serviços, agentes)
  │
  ├── 1:N → Session (sessões ativas)
  │
  ├── 1:N → Context (contextos operacionais)
  │
  ├── 1:N → Authorization (regras de permissão)
  │
  ├── 1:N → Discovery (capabilities disponíveis)
  │
  ├── 1:N → Registry (módulos, capabilities, ferramentas)
  │
  ├── 1:N → Capability (capacidades habilitadas)
  │
  ├── 1:N → Runtime (execuções)
  │
  ├── 1:N → Navigation (menus)
  │
  ├── 1:N → Workflow (fluxos)
  │
  ├── 1:N → Event (eventos)
  │
  ├── 1:N → Ledger (registros imutáveis)
  │
  └── 1:N → Integration (integrações externas)
```

### 7.2 Tenant como organização

```text
Tenant
  │
  ├── Identidade organizacional (nome, CNPJ, tipo)
  │
  ├── Configurações (parâmetros, módulos, integrações)
  │
  ├── Membros (pessoas, usuários, serviços)
  │
  ├── Estrutura (unidades, locais, setores)
  │
  ├── Regras (permissões, workflows, políticas)
  │
  └── Histórico (eventos, auditoria, evoluções)
```

### 7.3 Separação de conceitos

```text
Tenant
  │
  ├── NÃO é Unidade
  │     └── Unidade existe DENTRO do Tenant
  │
  ├── NÃO é Local
  │     └── Local existe DENTRO do Tenant
  │
  ├── NÃO é Setor
  │     └── Setor existe DENTRO do Tenant
  │
  ├── NÃO é Usuário
  │     └── Usuário existe DENTRO do Tenant
  │
  └── NÃO é Módulo
        └── Módulo pode ser habilitado POR Tenant
```

Exemplo de estrutura correta:

```text
Tenant: Hospital São Paulo
  │
  ├── Unidades
  │     ├── UPA Centro
  │     ├── UBS Norte
  │     └── Farmácia
  │
  ├── Usuários
  │     ├── Médicos
  │     ├── Enfermeiros
  │     └── Administrativos
  │
  └── Módulos habilitados
        ├── Assistencial
        ├── Farmácia
        └── Faturamento
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Pessoa/Usuário/Serviço pertence a Tenant |

### 8.2 É dependido por

| Domínio | Como depende de Tenant |
|---------|------------------------|
| Session | Sessão é vinculada a um Tenant |
| Context | Contexto é resolvido dentro de um Tenant |
| Authorization | Permissão é validada dentro de um Tenant |
| Discovery | Discovery resolve capabilities por Tenant |
| Registry | Registry é consultado por Tenant |
| Capability | Capability é habilitada por Tenant |
| Runtime | Runtime opera dentro de um Tenant |
| Navigation | Navigation projeta menu por Tenant |
| Workflow | Workflow é executado dentro de um Tenant |
| Event | Evento é registrado por Tenant |
| Ledger | Ledger registra por Tenant |
| Integration | Integration autentica por Tenant |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant |
| ------------ | -------- | ------ |
| Identity     | —        |        |
| Tenant       |          | —      |
| Session      | ✔        | ✔      |
| Context      | ✔        | ✔      |
| Authorization| ✔        | ✔      |
| Discovery    | ✔        | ✔      |
| Registry     | ✔        | ✔      |
| Capability   | ✔        | ✔      |
| Runtime      | ✔        | ✔      |
| Navigation   | ✔        | ✔      |
| Workflow     | ✔        | ✔      |
| Event        | ✔        | ✔      |
| Ledger       | ✔        | ✔      |
| Integration  | ✔        | ✔      |

---

## 9. Estados Canônicos

### 9.1 Estados de Tenant

| Estado | Descrição |
|--------|-----------|
| CREATED | Tenant foi criado, aguardando configuração inicial |
| CONFIGURING | Tenant está em configuração (módulos, usuários, integrações) |
| ACTIVE | Tenant está operacional |
| SUSPENDED | Tenant está suspenso temporariamente (bloqueio, inadimplência, violação) |
| DISABLED | Tenant está desativado permanentemente |
| ARCHIVED | Tenant está arquivado (somente leitura) |

### 9.2 Regras de transição

```text
CREATED → CONFIGURING (início de configuração)
CONFIGURING → ACTIVE (configuração mínima concluída)
ACTIVE → SUSPENDED (bloqueio administrativo / inadimplência / violação)
SUSPENDED → ACTIVE (validação administrativa)
ACTIVE → DISABLED (desativação permanente)
DISABLED → ARCHIVED (arquivamento após período de retenção)
```

### 9.3 Regras de negócio

- Um Tenant SUSPENDED não pode criar novas sessões.
- Um Tenant DISABLED não pode ser reativado (apenas ARCHIVED).
- Um Tenant ARCHIVED é somente leitura.
- A transição para ACTIVE exige configuração mínima validada.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Tenant é a **Foundation Layer** do Kernel.

É o primeiro conceito organizacional após Identity.

```text
Cliente
  ↓
Identity (quem é?)
  ↓
Tenant (onde opera?)
  ↓
Session (qual sessão?)
  ↓
Context (qual contexto?)
  ↓
Authorization (pode?)
  ↓
Runtime (executa)
```

### 10.2 Contratos

Tenant não é uma SP. Tenant é um conceito.

Sua materialização será:
- Tabelas: `tenant_registry`, `saas_entidade`, etc.
- SPs: `sp_tenant_get`, `sp_tenant_create`, `sp_tenant_update`, `sp_tenant_suspend`, etc.
- Views: `vw_tenant_summary`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Tenant é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Identity pode pertencer a múltiplos tenants |
| Session | Session é sempre vinculada a um tenant |
| Context | Contexto é resolvido dentro de um tenant |
| Authorization | Permissão é validada por tenant |
| Discovery | Discovery resolve capabilities por tenant |
| Registry | Registry filtra por tenant |
| Capability | Capability é habilitada por tenant |
| Runtime | Runtime opera dentro de um tenant |
| Navigation | Navigation projeta menu por tenant |
| Workflow | Workflow é executado por tenant |
| Event | Evento é registrado por tenant |
| Ledger | Ledger registra por tenant |
| Integration | Integration autentica por tenant |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Isolamento natural entre organizações.
- Governança descentralizada por tenant.
- Configuração independente por cliente.
- Escalabilidade multi-tenant.
- Base sólida para SaaS.

### 11.2 Impactos negativos / Riscos

- Complexidade de isolamento: todas as queries devem filtrar por tenant.
- Performance: índices de tenant são obrigatórios.
- Migração: dados existentes precisam ser mapeados para tenants.
- Governança: políticas de tenant precisam ser documentadas.

### 11.3 Mitigações

- Filtro obrigatório de tenant em todas as queries.
- Índices em `id_tenant` em todas as tabelas relevantes.
- Auditoria de acesso por tenant.
- Políticas de retenção e arquivamento documentadas.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de tenant será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de tenant será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de tenant deve estar coerente com as SPs que a consomem.
12.4 Todo índice de tenant deve suportar as consultas mais frequentes.
12.5 Nenhuma operação pode existir sem filtro de tenant.
12.6 Toda operação de tenant deve gerar evento no Ledger.
12.7 A materialização depende da aprovação do MD-KERNEL-002 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-107 — Tenant Architecture
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-002 — Tenant |

---

Documento Canônico — MD-KERNEL-002

**Este é o segundo domínio do Kernel Enterprise. Depende de Identity e é pré-requisito para Session, Context e Authorization.**
