# MD-KERNEL-003 — Session

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Foundation Layer
Pré-requisito: MD-KERNEL-001 — Identity
Pré-requisito: MD-KERNEL-002 — Tenant
```

---

## 1. Objetivo

Definir o conceito canônico de **Session** no Kernel Enterprise.

Session é a camada responsável por responder:

> **"Qual é a minha instância autorizada de operação agora?"**

Ela não é apenas "login".
Ela é o **contrato de existência operacional temporária** dentro da plataforma.

---

## 2. Definição Canônica

```text
Session representa uma instância controlada de interação
entre uma Identity autenticada, um Tenant válido e um Runtime autorizado.

Session é:
  - temporária
  - autorizada
  - rastreável
  - vinculada a Identity e Tenant
  - base para autorização contextual

Sem Session válida:
  Identity existe, mas não opera.
```

### 2.1 Princípio fundamental

```text
Identity define quem existe.
Tenant define onde essa identidade pertence.
Session define uma instância autorizada de operação.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Temporária | Session tem início e fim definidos |
| Autorizada | Session é criada apenas após autenticação válida |
| Vinculada | Session pertence a uma Identity e um Tenant |
| Rastreável | Toda ação pode ser atribuída a uma Session |
| Revogável | Session pode ser encerrada a qualquer momento |
| Auditável | Toda criação, expiração e encerramento é registrado |

---

## 3. Boundaries

### 3.1 Session É

- Estado operacional temporário.
- Registro de autenticação ativa.
- Ponte entre Identity e Runtime.
- Base para autorização contextual.
- Origem de rastreabilidade operacional.

### 3.2 Session NÃO é

- ❌ **Identity**: não representa quem é o usuário.
- ❌ **Usuário**: não é a credencial de acesso.
- ❌ **Permissão**: não define o que pode ser feito.
- ❌ **Perfil**: não representa um papel.
- ❌ **Contexto definitivo**: não carrega unidade/local permanentemente.
- ❌ **Token isolado**: é um conceito, não um artifact técnico.
- ❌ **Login único**: uma Identity pode ter múltiplas sessões simultâneas.

### 3.3 Limites claros

```text
SESSION
  │
  ├── É responsável por: autenticação ativa, ciclo de vida, rastreabilidade
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── permissões (Authorization)
        ├── contexto operacional (Context)
        ├── execução (Runtime)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Vincular Identity à sessão ativa.
4.2 Vincular Tenant à sessão ativa.
4.3 Controlar ciclo de vida (criação, autenticação, ativação, ociosidade, expiração, revogação, encerramento).
4.4 Garantir rastreabilidade de todas as operações.
4.5 Servir como base para Authorization e Context.
4.6 Permitir múltiplas sessões simultâneas por Identity.
4.7 Suportar revogação administrativa e automática.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Serviço de Autenticação | Cria sessão após validação de credenciais |
| Runtime Autorizado | Pode criar sessão para identidades técnicas (serviços, APIs) |
| Integrações Confiáveis | Podem solicitar criação de sessão via contrato canônico |
| Administração | Pode revogar sessões administrativamente |

---

## 6. Consumidores

| Consumidor | Como usa |
|-------------|----------|
| Authorization | Valida permissões no contexto da sessão |
| Context | Resolve contexto operacional da sessão |
| Discovery | Descobre capabilities disponíveis para a sessão |
| Registry | Filtra por sessão/tenant |
| Capability | Executa capability no contexto da sessão |
| Runtime | Valida sessão antes de executar |
| Navigation | Projeta menu baseado na sessão |
| Workflow | Inicia workflow no contexto da sessão |
| Event | Registra eventos com referência à sessão |
| Ledger | Registra operações atribuídas à sessão |
| Notification | Endereça notificações à sessão/identity |
| Integration | Valida sessão para chamadas externas |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Session
  │
  ├── 1:1 → Identity (quem está operando)
  │
  ├── 1:1 → Tenant (onde opera)
  │
  ├── 1:N → Context (contextos alternativos durante a sessão)
  │
  ├── 1:N → Authorization (permissões validadas na sessão)
  │
  ├── 1:N → Event (eventos gerados na sessão)
  │
  ├── 1:N → Ledger (registros imutáveis da sessão)
  │
  └── 1:N → Notification (notificações da sessão)
```

### 7.2 Modelo conceitual

```text
Identity
  │
  ├── 1:N → Session
           │
           ├── Tenant
           │
           ├── Context
           │
           ├── Runtime
           │
           └── Operation
```

### 7.3 Múltiplas sessões

```text
Identity: João Silva
  │
  ├── Session A (Web - UPA Centro)
  │     ├── Tenant: Hospital SP
  │     ├── Context: Unidade UPA
  │     └── Runtime: Portal
  │
  ├── Session B (Mobile - UBS Norte)
  │     ├── Tenant: Hospital SP
  │     ├── Context: Unidade UBS
  │     └── Runtime: Mobile
  │
  └── Session C (API - Integração)
        ├── Tenant: Hospital SP
        ├── Context: Serviço Técnico
        └── Runtime: API
```

Uma mesma Identity pode ter múltiplas sessões simultâneas em diferentes contextos.

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Session pertence a uma Identity |
| Tenant | Session opera dentro de um Tenant |

### 8.2 É dependido por

| Domínio | Como depende de Session |
|---------|--------------------------|
| Context | Contexto é resolvido no âmbito de uma Session |
| Authorization | Permissão é validada para uma Session |
| Discovery | Discovery filtra capabilities por Session |
| Registry | Registry consulta no contexto de uma Session |
| Capability | Capability é executada em nome de uma Session |
| Runtime | Runtime valida Session antes de executar |
| Navigation | Navigation projeta menu para uma Session |
| Workflow | Workflow é iniciado por uma Session |
| Event | Evento é registrado com referência à Session |
| Ledger | Ledger registra operações de uma Session |
| Integration | Integration valida Session para chamadas externas |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session |
| ------------ | -------- | ------ | ------- |
| Identity     | —        |        |         |
| Tenant       |          | —      |         |
| Session      | ✔        | ✔      | —       |
| Context      | ✔        | ✔      | ✔       |
| Authorization| ✔        | ✔      | ✔       |
| Discovery    | ✔        | ✔      | ✔       |
| Registry     | ✔        | ✔      | ✔       |
| Capability   | ✔        | ✔      | ✔       |
| Runtime      | ✔        | ✔      | ✔       |
| Navigation   | ✔        | ✔      | ✔       |
| Workflow     | ✔        | ✔      | ✔       |
| Event        | ✔        | ✔      | ✔       |
| Ledger       | ✔        | ✔      | ✔       |
| Integration  | ✔        | ✔      | ✔       |

---

## 9. Estados Canônicos

### 9.1 Estados de Session

| Estado | Descrição |
|--------|-----------|
| CREATED | Session foi criada, aguardando autenticação |
| AUTHENTICATED | Identity foi validada com sucesso |
| ACTIVE | Session está operacional |
| IDLE | Session está ativa mas inativa há mais tempo que o limite |
| EXPIRED | Session expirou por tempo limite |
| REVOKED | Session foi revogada administrativamente |
| CLOSED | Session foi encerrada normalmente |

### 9.2 Regras de transição

```text
CREATED → AUTHENTICATED (credenciais válidas)
AUTHENTICATED → ACTIVE (tenant confirmado, contexto inicial carregado)
ACTIVE → IDLE (ausência de atividade por período configurado)
ACTIVE → EXPIRED (tempo limite atingido)
ACTIVE → REVOKED (revogação administrativa / risco detectado)
IDLE → ACTIVE (atividade retomada)
IDLE → EXPIRED (tempo limite de idle atingido)
EXPIRED → CLOSED (encerramento automático)
REVOKED → CLOSED (encerramento forçado)
```

### 9.3 Regras de negócio

- Uma Session EXPIRED ou REVOKED não pode ser reativada.
- Uma Session IDLE pode ser reativada automaticamente com atividade.
- O limite de idle é configurável por Tenant.
- O tempo de vida máximo é configurável por Tenant.
- A revogação administrativa é imediata e irreversível.
- Toda transição de estado deve gerar evento no Ledger.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Session é a **Foundation Layer** do Kernel.

É a ponte entre Identity/Tenant e todo o resto do Kernel.

```text
Cliente
  ↓
Identity (quem é?)
  ↓
Tenant (onde opera?)
  ↓
Session (está autorizado agora?)
  ↓
Context (qual contexto?)
  ↓
Authorization (pode?)
  ↓
Runtime (executa)
```

### 10.2 Contratos

Session não é uma SP. Session é um conceito.

Sua materialização será:
- Tabelas: `sessao_usuario`, `auth_sessao`, etc.
- SPs: `sp_session_create`, `sp_session_validate`, `sp_session_revoke`, `sp_session_expire`, etc.
- Views: `vw_session_active`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Session é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Session é criada para uma Identity |
| Tenant | Session opera dentro de um Tenant |
| Context | Contexto é resolvido no âmbito de uma Session |
| Authorization | Permissão é validada para uma Session |
| Discovery | Discovery filtra por Session |
| Registry | Registry consulta no contexto de uma Session |
| Capability | Capability é executada em nome de uma Session |
| Runtime | Runtime valida Session antes de executar |
| Navigation | Navigation projeta menu para uma Session |
| Workflow | Workflow é iniciado por uma Session |
| Event | Evento é registrado com referência à Session |
| Ledger | Ledger registra operações de uma Session |
| Integration | Integration autentica via Session |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Base sólida para autenticação e autorização.
- Rastreabilidade completa de operações.
- Suporte a múltiplas sessões simultâneas.
- Revogação imediata de acesso.
- Ciclo de vida controlado e auditável.

### 11.2 Impactos negativos / Riscos

- Complexidade de gerenciamento de sessões.
- Performance: consultas de sessão são frequentes.
- Segurança: sessões roubadas ou não encerradas.
- Migração: sessões existentes precisam ser preservadas durante transição.

### 11.3 Mitigações

- Índices otimizados para consulta de sessão ativa.
- Política de expiração automática.
- Auditoria de todas as transições de estado.
- Revogação em massa quando necessário.
- Testes de segurança desde o início.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de session será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de session será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de session deve estar coerente com as SPs que a consomem.
12.4 Todo índice de session deve suportar as consultas mais frequentes (busca por identity, tenant, status, expiração).
12.5 Nenhuma operação do Kernel pode existir sem Session válida.
12.6 Toda transição de estado de Session deve gerar evento no Ledger.
12.7 A materialização depende da aprovação do MD-KERNEL-003 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-003 — Session |

---

Documento Canônico — MD-KERNEL-003

**Este é o terceiro domínio do Kernel Enterprise. Depende de Identity e Tenant, e é pré-requisito para Context, Authorization e Runtime.**
