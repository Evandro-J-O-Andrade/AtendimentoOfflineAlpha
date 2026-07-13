# MAP-RUNTIME-FLOW

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Mapa de fluxo de runtime da plataforma.
```

---

## 1. Propósito

Este documento apresenta o **fluxo canônico de runtime** da plataforma New Wave Enterprise.

Ele serve para:
- Visualizar o caminho de uma operação no Kernel
- Entender como os domínios se conectam em tempo de execução
- Orientar implementação de backend e frontend
- Servir como referência para debugging

Runtime não é apenas código.
Runtime é o **caminho de vida de uma operação**.

---

## 2. Fluxo Principal

### 2.1 Visão geral

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
Ledger (preserva evidências)
  ↓
Integration (conecta externamente)
  ↓
Resposta
```

### 2.2 Fluxo simplificado

```text
Login
  ↓
Session
  ↓
Context
  ↓
Authorization
  ↓
Discovery
  ↓
Capability
  ↓
Runtime
  ↓
Navigation
  ↓
Produto
```

---

## 3. Fluxos Detalhados

### 3.1 Fluxo de Login

```text
Usuário
 ↓
Frontend (Login)
 ↓
Auth Contract: POST /api/v1/auth/login
 ↓
Backend (Auth Runtime)
 ↓
Identity: valida identidade
 ↓
Session: cria sessão
 ↓
Authorization: avalia acesso inicial
 ↓
Context: resolve contexto padrão
 ↓
Event: SessaoCriada
 ↓
Ledger: registra evidência
 ↓
Response: session + token + context
 ↓
Frontend: armazena sessão
 ↓
Navigation: projeta menu inicial
 ↓
Portal UI
```

### 3.2 Fluxo de Seleção de Contexto

```text
Usuário
 ↓
Frontend (Context Selection)
 ↓
Context Contract: POST /api/v1/context/options
 ↓
Backend (Context Runtime)
 ↓
Identity: carrega identidade
 ↓
Tenant: carrega tenant
 ↓
Session: valida sessão
 ↓
Context: lista opções disponíveis
 ↓
Response: unidades, locais, perfis
 ↓
Frontend: exibe opções
 ↓
Usuário seleciona
 ↓
Context Contract: POST /api/v1/context/switch
 ↓
Backend (Context Runtime)
 ↓
Authorization: valida permissão para contexto
 ↓
Context: aplica novo contexto
 ↓
Event: ContextoAlterado
 ↓
Ledger: registra evidência
 ↓
Response: novo contexto
 ↓
Frontend: atualiza estado
 ↓
Navigation: projeta menu para novo contexto
 ↓
Portal UI
```

### 3.3 Fluxo de Descoberta

```text
Frontend (Portal)
 ↓
Navigation Contract: POST /api/v1/navigation/project
 ↓
Backend (Navigation Runtime)
 ↓
Discovery: consulta capabilities disponíveis
 ↓
Registry: carrega catálogo
 ↓
Authorization: filtra por permissão
 ↓
Context: aplica contexto operacional
 ↓
Capability: lista capabilities disponíveis
 ↓
Response: projeção de navegação
 ↓
Frontend: renderiza menu
 ↓
Portal UI
```

### 3.4 Fluxo de Execução

```text
Usuário
 ↓
Frontend (Ação)
 ↓
Runtime Contract: POST /api/v1/runtime/execute
 ↓
Backend (Runtime)
 ↓
Identity: valida identidade
 ↓
Tenant: valida tenant
 ↓
Session: valida sessão ativa
 ↓
Context: aplica contexto
 ↓
Authorization: valida permissão para capability
 ↓
Registry: valida capability existe
 ↓
Capability: carrega definição
 ↓
Runtime: executa capability
 ↓
Event: ExecucaoRealizada
 ↓
Ledger: registra evidência
 ↓
Response: resultado
 ↓
Frontend: atualiza UI
 ↓
Portal UI
```

### 3.5 Fluxo de Workflow

```text
Usuário
 ↓
Frontend (Ação)
 ↓
Workflow Contract: POST /api/v1/workflow/start
 ↓
Backend (Workflow Runtime)
 ↓
Identity: valida identidade
 ↓
Tenant: valida tenant
 ↓
Session: valida sessão
 ↓
Context: aplica contexto
 ↓
Authorization: valida permissão para iniciar workflow
 ↓
Workflow: cria processo
 ↓
Event: WorkflowIniciado
 ↓
Ledger: registra evidência
 ↓
Response: processo criado
 ↓
Frontend: exibe estado
 ↓
Usuário ação
 ↓
Workflow Contract: POST /api/v1/workflow/transition
 ↓
Backend (Workflow Runtime)
 ↓
Authorization: valida permissão para transição
 ↓
Workflow: valida transição
 ↓
Workflow: aplica transição
 ↓
Event: WorkflowTransicionado
 ↓
Ledger: registra evidência
 ↓
Response: novo estado
 ↓
Frontend: atualiza UI
```

### 3.6 Fluxo de Integração

```text
Sistema Externo
 ↓
Integration Contract
 ↓
Backend (Integration Runtime)
 ↓
Identity: valida identidade do sistema
 ↓
Tenant: valida tenant autorizado
 ↓
Session: valida sessão (se aplicável)
 ↓
Context: aplica contexto
 ↓
Authorization: valida permissão de integração
 ↓
Registry: valida integração registrada
 ↓
Integration: executa adaptação
 ↓
Runtime: executa via Runtime
 ↓
Event: IntegracaoExecutada
 ↓
Ledger: registra evidência
 ↓
Response: adaptado
 ↓
Sistema Externo
```

---

## 4. Estados do Runtime

### 4.1 Estados de operação

| Estado | Descrição |
|--------|-----------|
| IDLE | Aguardando solicitação |
| VALIDATING | Validando identidade, tenant, sessão, contexto, autorização |
| RESOLVING | Resolvendo capability e executor |
| EXECUTING | Executando operação |
| WAITING | Aguardando recurso externo |
| COMPENSATING | Executando compensação |
| SYNCING | Sincronizando estado offline |
| COMPLETED | Concluído |
| FAILED | Falhou |
| CANCELLED | Cancelado |

### 4.2 Transições

```text
IDLE → VALIDATING
VALIDATING → RESOLVING
VALIDATING → FAILED
RESOLVING → EXECUTING
RESOLVING → FAILED
EXECUTING → COMPLETED
EXECUTING → WAITING
EXECUTING → FAILED
WAITING → EXECUTING
WAITING → FAILED
EXECUTING → COMPENSATING
COMPENSATING → COMPLETED
COMPENSATING → FAILED
EXECUTING → CANCELLED
COMPLETED → SYNCING
SYNCING → COMPLETED
FAILED → IDLE
CANCELLED → IDLE
```

---

## 5. Eventos

### 5.1 Eventos de Auth

| Evento | Quando |
|--------|--------|
| SessaoCriada | Sessão criada |
| SessaoAutenticada | Sessão autenticada |
| SessaoIniciada | Sessão iniciada |
| SessaoExpirada | Sessão expirada |
| SessaoRevogada | Sessão revogada |
| SessaoEncerrada | Sessão encerrada |

### 5.2 Eventos de Context

| Evento | Quando |
|--------|--------|
| ContextoResolvido | Contexto resolvido |
| ContextoAlterado | Contexto trocado |
| ContextoSuspenso | Contexto suspenso |
| ContextoReativado | Contexto reativado |
| ContextoEncerrado | Contexto encerrado |

### 5.3 Eventos de Runtime

| Evento | Quando |
|--------|--------|
| ExecucaoIniciada | Execução iniciada |
| ExecucaoConcluida | Execução concluída |
| ExecucaoFalhou | Execução falhou |
| ExecucaoCancelada | Execução cancelada |
| ExecucaoCompensada | Execução compensada |

### 5.4 Eventos de Workflow

| Evento | Quando |
|--------|--------|
| WorkflowIniciado | Workflow iniciado |
| WorkflowTransicionado | Workflow transicionado |
| WorkflowConcluido | Workflow concluído |
| WorkflowFalhou | Workflow falhou |
| WorkflowCancelado | Workflow cancelado |
| WorkflowCompensado | Workflow compensado |

### 5.5 Eventos de Integration

| Evento | Quando |
|--------|--------|
| IntegracaoIniciada | Integração iniciada |
| IntegracaoConcluida | Integração concluída |
| IntegracaoFalhou | Integração falhou |

---

## 6. Integração com Kernel

### 6.1 Papel no Kernel

Runtime é o **caminho de vida** de uma operação no Kernel.

```text
Cliente
  ↓
Identity
  ↓
Tenant
  ↓
Session
  ↓
Context
  ↓
Authorization
  ↓
Registry
  ↓
Discovery
  ↓
Capability
  ↓
Runtime
  ↓
Workflow
  ↓
Event
  ↓
Ledger
  ↓
Integration
  ↓
Cliente
```

### 6.2 Domínios envolvidos

| Domínio | Papel no Runtime |
|---------|------------------|
| Identity | Quem opera |
| Tenant | Onde opera |
| Session | Autorização temporária |
| Context | Escopo operacional |
| Authorization | Pode executar? |
| Registry | O que existe? |
| Discovery | O que está disponível? |
| Capability | O que executar? |
| Runtime | Como executar? |
| Workflow | Qual fluxo? |
| Event | O que aconteceu? |
| Ledger | Prova histórica |
| Integration | Como conectar? |

---

## 7. Regras de Governança

### 7.1 Fluxo obrigatório

```text
Toda operação deve passar por:
1. Identity
2. Session
3. Context
4. Authorization
5. Runtime

Nenhuma operação pula etapas.
```

### 7.2 Imutabilidade

```text
Evento uma vez criado é imutável.
Ledger uma vez registrado é imutável.
Nenhuma camada pode alterar passado.
```

### 7.3 Rastreabilidade

```text
Toda operação deve ter:
- Identity
- Tenant
- Session
- Context
- Timestamp
- Event
- Ledger
```

---

## 8. Próximos Artefatos

| Prioridade | Artefato | Descrição |
|------------|----------|-----------|
| Alta | MAP-DATA-CANONICAL.md | Mapa de dados canônicos |
| Alta | REVIEW-KERNEL-TRANSVERSAL.md | Revisão transversal |
| Média | MODEL-LOGICAL-KERNEL.md | Modelo lógico |
| Média | MODEL-PHYSICAL-KERNEL.md | Modelo físico |
| Média | SP-KERNEL-CATALOG.md | Catálogo de procedures |

---

## 9. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 até MD-KERNEL-014
- MAP-CORE-PLATFORM
- BR-CATALOG
- FRONT-CATALOG
- FRONTEND-AUDIT
- ASSET-INVENTORY
- FRONT-DESIGN-SYSTEM
- FRONTEND-ARCHITECTURE
- FRONT-KERNEL-MAP
- FRONT-CONTRACTS
- FRONTEND-TESTING
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- 000-CONSTITUICAO-IA.md

---

## 10. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do mapa de runtime |

---

Documento Canônico — MAP-RUNTIME-FLOW

**Este é o documento oficial de fluxo de runtime da plataforma New Wave Enterprise.**
