# MD-KERNEL-005 — Authorization

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Governance Layer
Pré-requisito: MD-KERNEL-001 — Identity
Pré-requisito: MD-KERNEL-002 — Tenant
Pré-requisito: MD-KERNEL-003 — Session
Pré-requisito: MD-KERNEL-004 — Context
```

---

## 1. Objetivo

Definir o conceito canônico de **Authorization** no Kernel Enterprise.

Authorization é a camada responsável por responder:

> **"Esta operação é permitida?"**

Ela não é apenas "permissão".
Ela não é "role".
Ela é a **decisão centralizada de acesso** que combina identidade, tenant, sessão, contexto, recurso, operação e política.

Toda decisão de acesso da plataforma passa por Authorization.
Nenhuma aplicação decide permissão por conta própria.

---

## 2. Definição Canônica

```text
Authorization representa o processo de avaliação
e decisão sobre se uma identidade autenticada,
dentro de um tenant válido, em uma sessão ativa
e um contexto operacional resolvido, pode executar
determinada operação sobre determinado recurso.

Authorization é:
  - decisão
  - centralizada
  - auditável
  - multi-tenant
  - contextual
  - baseada em política
  - independente de tecnologia

Sem Authorization válida:
  operação não ocorre,
  mesmo com sessão ativa.
```

### 2.1 Princípio fundamental

```text
Acesso não é cargo.
Acesso é decisão.

Decisão é:
  identidade + tenant + sessão + contexto
  + recurso + operação + política.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Centralizada | A decisão de acesso é única para toda a plataforma |
| Auditável | Toda decisão é registrada no Ledger |
| Contextual | Leva em conta o contexto operacional corrente |
| Multi-tenant | Respeita isolamento entre tenants |
| Política-driven | Baseada em regras documentadas, não hardcoded |
| Imutável | Decisão é ponto no tempo; não é alterada retroativamente |
| Reversível | Decisão negativa pode ser revista |
| Consistente | Mesma entrada sempre produz mesma saída |

### 2.3 Dimensões da decisão

| Dimensão | Natureza | Observação |
|----------|----------|------------|
| Quem | Identity | Identidade autenticada |
| Onde | Tenant | Tenant válido e ativo |
| Quando | Session | Sessão ativa e não expirada |
| Como | Context | Contexto operacional resolvido |
| O quê | Recurso | Entidade, módulo, capability, endpoint |
| Ação | Operação | Ler, criar, alterar, excluir, executar, administrar |
| Por quê | Política | Regra, perfil, papel, exceção, restrição |

---

## 3. Boundaries

### 3.1 Authorization É

- A decisão final sobre acesso.
- O ponto de avaliação de permissões.
- A camada que transforma regras em decisão.
- A origem de auditoria de acesso.
- O mecanismo de imposição de isolamento.
- A base para negar operações não autorizadas.

### 3.2 Authorization NÃO é

- ❌ **Identity**: não define quem é o usuário.
- ❌ **Tenant**: não define a organização isolada.
- ❌ **Session**: não representa a autenticação ativa.
- ❌ **Context**: não define o escopo operacional.
- ❌ **Permissão isolada**: permissão é entrada, não a decisão.
- ❌ **Role / Perfil fixo**: papel é um atributo, não a decisão completa.
- ❌ **Regra de negócio**: não define o que acontece após a permissão.
- ❌ **Interface**: não exibe nada ao usuário.
- ❌ **Cache**: não armazena decisão como verdade definitiva.

### 3.3 Limites claros

```text
AUTHORIZATION
  │
  ├── É responsável por: decisão de acesso, avaliação de política, auditoria
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── descoberta (Discovery)
        ├── execução (Runtime)
        ├── regra de negócio (SP)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Avaliar solicitações de acesso recebendo identidade, tenant, sessão, contexto, recurso e operação.
4.2 Aplicar políticas de acesso de forma centralizada.
4.3 Produzir decisão binária: PERMITIDO ou NEGADO.
4.4 Produzir motivo legível da decisão.
4.5 Registrar toda decisão no Ledger para auditoria.
4.6 Suportar avaliação em tempo real e em lote.
4.7 Permitir revisão e contestação de decisões.
4.8 Garantir que nenhuma operação cruze tenant sem autorização explícita.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Administração da Plataforma | Define políticas globais e exceções |
| Administração do Tenant | Define regras específicas do tenant |
| Sistema de Perfis | Atribui perfis e papéis a identidades |
| Auditoria | Revisa decisões e sugere ajustes de política |
| IA | Sugere políticas baseadas em padrões operacionais (não decide) |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Runtime | Consulta Authorization antes de executar qualquer operação |
| Discovery | Filtra capabilities por decisão de Authorization |
| Registry | Responde consultas respeitando decisões de Authorization |
| Capability | Executa apenas capabilities autorizadas |
| Navigation | Projeta menu baseado em decisões de Authorization |
| Workflow | Inicia apenas workflows autorizados |
| Event | Registra eventos de operações autorizadas |
| Ledger | Persiste decisões de Authorization como fonte de verdade |
| Integration | Valida Authorization para chamadas externas |
| Portal | Aplica Authorization na navegação e seleção de contexto |
| IA | Consulta Authorization antes de sugerir ações |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Authorization
  │
  ├── Identity (quem solicita)
  │
  ├── Tenant (onde solicita)
  │
  ├── Session (qual sessão)
  │
  ├── Context (qual contexto operacional)
  │
  ├── Policy (qual regra aplica)
  │
  ├── Decision (permitido / negado)
  │
  ├── Reason (motivo legível)
  │
  ├── 1:N → Ledger (registro imutável)
  │
  └── 1:N → Event (evento de acesso)
```

### 7.2 Modelo conceitual

```text
Solicitação de Acesso
  │
  ├── Identity
  ├── Tenant
  ├── Session
  ├── Context
  ├── Recurso
  └── Operação
        │
        ▼
  Authorization Engine
        │
        ├── Carrega políticas aplicáveis
        ├── Avalia atributos
        ├── Aplica regras
        ├── Verifica exceções
        ├── Produz decisão
        └── Registra no Ledger
              │
              ▼
        Decisão
          ├── PERMITIDO → Executa operação
          └── NEGADO    → Bloqueia operação + Motivo
```

### 7.3 Decisão como evento

```text
Authorization não é estática.

Cada decisão é:
  - única
  - datada
  - associada a uma sessão
  - registrada no Ledger
  - consultável
  - auditável

Histórico de Authorization é fonte da verdade.
```

### 7.4 Separação de conceitos

```text
AUTHORIZATION
  │
  ├── NÃO é Authentication
  │     └── Authentication valida identidade
  │
  ├── NÃO é Permission
  │     └── Permission é uma regra genérica
  │
  ├── NÃO é Role
  │     └── Role agrupa permissões
  │
  ├── NÃO é Policy
  │     └── Policy é o conjunto de regras
  │
  ├── NÃO é Decision
  │     └── Decision é o resultado de Authorization
  │
  └── NÃO é Enforcement
        └── Enforcement é a aplicação da decisão
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Authorization avalia identidade |
| Tenant | Authorization opera dentro de um tenant |
| Session | Authorization valida sessão ativa |
| Context | Authorization aplica contexto operacional |

### 8.2 É dependido por

| Domínio | Como depende de Authorization |
|---------|--------------------------------|
| Discovery | Discovery filtra capabilities por Authorization |
| Registry | Registry respeita decisões de Authorization |
| Capability | Capability executa apenas se autorizado |
| Runtime | Runtime valida Authorization antes de executar |
| Navigation | Navigation projeta menu por Authorization |
| Workflow | Workflow inicia apenas se autorizado |
| Event | Evento registra apenas operações autorizadas |
| Ledger | Ledger persiste decisões de Authorization |
| Integration | Integration valida Authorization externamente |
| Notification | Notification respeita permissões de Authorization |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization |
| ------------ | -------- | ------ | ------- | ------- | ------------- |
| Identity     | —        |        |         |         |               |
| Tenant       |          | —      |         |         |               |
| Session      | ✔        | ✔      | —       |         |               |
| Context      | ✔        | ✔      | ✔       | —       |               |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             |
| Registry     |          |        | ✔       | ✔       | ✔             |
| Capability   |          |        | ✔       | ✔       | ✔             |
| Runtime      |          |        | ✔       | ✔       | ✔             |
| Navigation   |          |        | ✔       | ✔       | ✔             |
| Workflow     |          |        | ✔       | ✔       | ✔             |
| Event        |          |        | ✔       | ✔       | ✔             |
| Ledger       |          |        | ✔       | ✔       | ✔             |
| Integration  |          |        | ✔       | ✔       | ✔             |

---

## 9. Estados Canônicos

### 9.1 Estados do ciclo de decisão

| Estado | Descrição |
|--------|-----------|
| REQUESTED | Solicitação de acesso recebida |
| EVALUATING | Authorization Engine processando regras |
| PERMITTED | Acesso permitido |
| DENIED | Acesso negado |
| CONDITIONAL | Acesso permitido com condições |
| EXPIRED | Decisão expirou (sessão ou contexto alterado) |
| REVOKED | Decisão revogada administrativamente |

### 9.2 Regras de transição

```text
REQUESTED → EVALUATING (avaliação iniciada)
EVALUATING → PERMITTED (políticas atendidas)
EVALUATING → DENIED (políticas não atendidas)
EVALUATING → CONDITIONAL (parcialmente atendida, com restrições)
PERMITTED → EXPIRED (sessão, contexto ou política expirou)
PERMITTED → REVOKED (revogação administrativa)
CONDITIONAL → PERMITTED (condições atendidas)
CONDITIONAL → DENIED (condições não atendidas)
DENIED → REVOKED (revogação de exceção anterior)
```

### 9.3 Regras de negócio

- Toda decisão de Authorization é PONTO NO TEMPO. Não pode ser alterada retroativamente.
- Decisão PERMITTED não garante execução; Runtime valida novamente no momento da operação.
- Decisão CONDITIONAL exige registro claro das condições aplicadas.
- Decisão DENIED deve incluir motivo legível para auditoria.
- Toda transição de estado de Authorization deve gerar evento no Ledger.
- Authorization NUNCA armazena segredos, senhas ou credenciais.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Authorization é a **Governance Layer** do Kernel.

É a primeira camada de governança e a primeira camada que transforma conceitos Foundation em ação controlada.

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
Runtime (executa)
```

### 10.2 Contratos

Authorization não é uma SP. Authorization é um conceito.

Sua materialização será:
- Tabelas: `auth_decision`, `auth_policy`, `auth_role_permission`, etc.
- SPs: `sp_auth_evaluate`, `sp_auth_permit`, `sp_auth_deny`, `sp_auth_audit`, etc.
- Views: `vw_auth_active`, `vw_auth_history`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Authorization é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Authorization avalia atributos da identidade |
| Tenant | Authorization isola decisão por tenant |
| Session | Authorization valida sessão ativa |
| Context | Authorization aplica contexto operacional |
| Discovery | Discovery consulta Authorization para filtrar capabilities |
| Registry | Registry respeita decisões de Authorization |
| Capability | Capability executa apenas se Authorization permitir |
| Runtime | Runtime valida Authorization antes de executar |
| Navigation | Navigation projeta menu baseado em Authorization |
| Workflow | Workflow inicia apenas se Authorization permitir |
| Event | Evento registra apenas operações autorizadas |
| Ledger | Ledger persiste decisões de Authorization |
| Integration | Integration valida Authorization para chamadas externas |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza a decisão de acesso em um ponto único.
- Elimina decisões de acesso espalhadas por aplicações.
- Torna a auditoria de acesso completa e confiável.
- Suporta políticas granulares e contextualizadas.
- Permite revisão e melhoria contínua de regras.
- Garante isolamento multi-tenant em todas as operações.
- Cria base para compliance e LGPD.

### 11.2 Impactos negativos / Riscos

- Complexidade de avaliação: políticas podem ser numerosas e conflitantes.
- Performance: avaliação de Authorization é crítica em toda requisição.
- Cegueira de desempenho: má política gera negação legítima percebida como falha.
- Migração: regras de acesso legadas precisam ser mapeadas.
- Governança: políticas sem dono ficam obsoletas rapidamente.

### 11.3 Mitigações

- Motor de avaliação otimizado e cache de decisão quando seguro.
- Políticas versionadas e com dono definido.
- Métricas de desempenho de Authorization.
- Revisão periódica de políticas por tenant.
- Testes de regressão de acesso automatizados.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de authorization será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de authorization será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de authorization deve estar coerente com as SPs que a consomem.
12.4 Todo índice de authorization deve suportar as consultas mais frequentes (avaliação por identity, tenant, contexto, recurso).
12.5 Nenhuma operação do Kernel pode existir sem Authorization válida.
12.6 Toda decisão de Authorization deve gerar evento no Ledger.
12.7 Nenhuma regra de Authorization pode residir em frontend ou aplicação.
12.8 A materialização depende da aprovação do MD-KERNEL-005 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MD-KERNEL-004 — Context
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
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-005 — Authorization |

---

Documento Canônico — MD-KERNEL-005

**Este é o quinto domínio do Kernel Enterprise. Depende de Foundation Layer e é pré-requisito para Discovery, Registry, Capability e Runtime.**
