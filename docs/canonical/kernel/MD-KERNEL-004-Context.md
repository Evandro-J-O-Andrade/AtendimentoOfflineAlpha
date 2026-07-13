# MD-KERNEL-004 — Context

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Foundation Layer
Pré-requisito: MD-KERNEL-001 — Identity
Pré-requisito: MD-KERNEL-002 — Tenant
Pré-requisito: MD-KERNEL-003 — Session
```

---

## 1. Objetivo

Definir o conceito canônico de **Context** no Kernel Enterprise.

Context é a camada responsável por responder:

> **"Em qual contexto operacional estou atuando?"**

Ele não é apenas "unidade ou local".
Ele é o **filtro operacional variável** que determina o escopo de atuação de uma identidade momentaneamente autorizada dentro de um tenant.

Sem Context válido:

```text
Session existe
mas
não tem escopo operacional.
```

---

## 2. Definição Canônica

```text
Context representa o conjunto de atributos operacionais
que definem o escopo de atuação de uma Session
dentro de um Tenant válido.

Context é:
  - variável
  - resolvido
  - vinculado a Identity, Tenant e Session
  - formado por unidade, local, perfil, sistema, aplicação e ambiente
  - base para autorização contextual
  - chave de isolamento operacional

Uma Identity pode alternar entre múltiplos Contexts
sem perder sua existência permanente.
```

### 2.1 Princípio fundamental

```text
Identity é permanente.
Contexto é variável.

Um usuário pode operar em múltiplos tenants,
unidades, locais, perfis e aplicações,
sem criar nova conta,
sem perder histórico,
sem perder permissões.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Variável | Context pode ser alterado durante a operação |
| Resolvido | Context é construído a partir de atributos operacionais válidos |
| Vinculado | Context pertence a uma Identity, um Tenant e uma Session |
| Isolante | Context define o escopo de dados acessíveis |
| Mutável | Context pode ser atualizado dentro dos limites permitidos |
| Auditável | Toda alteração de contexto é registrada |
| Multi-instância | Uma Identity pode alternar entre contextos distintos |

### 2.3 Atributos canônicos

| Atributo | Natureza | Observação |
|----------|----------|------------|
| Unidade | Organizacional | Unidade operacional dentro do Tenant |
| Local | Físico / Lógico | Local de atendimento, sala, setor, posto |
| Perfil | Funcional | Perfil de acesso assumido naquele momento |
| Sistema | Técnico | Sistema ou módulo em uso |
| Aplicação | Operacional | App em execução |
| Ambiente | Runtime | Produção, homologação, treinamento |
| Runtime | Execução | Canal de entrada: Web, Mobile, API, Display, Totem |

---

## 3. Boundaries

### 3.1 Context É

- Filtro operacional de isolamento.
- Resposta à pergunta "onde e como estou operando agora?".
- Base para Authorization diferenciar permissões por cenário.
- Origem de rastreabilidade operacional.
- Mecanismo de切换 (switch) de perfil e unidade sem recriar identidade.

### 3.2 Context NÃO é

- ❌ **Identity**: não define quem é o usuário.
- ❌ **Tenant**: não define a organização isolada.
- ❌ **Session**: não é a autenticação ativa.
- ❌ **Permissão**: não define o que pode ser feito.
- ❌ **Perfil fixo**: um usuário pode assumir perfis diferentes em momentos distintos.
- ❌ **Unidade definitiva**: contexto pode mudar de unidade durante a operação.
- ❌ **Configuração de produto**: não carrega parâmetros específicos de módulo.
- ❌ **Cache**: não é um atalho de performance.

### 3.3 Limites claros

```text
CONTEXT
  │
  ├── É responsável por: escopo operacional, filtro de dados, isolamento momentâneo
  │
  └── NÃO é responsável por:
        ├── existência (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── decisão de acesso (Authorization)
        ├── execução (Runtime)
        ├── discovery (Discovery)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Resolver o escopo operacional atual de uma Session.
4.2 Combinar atributos de unidade, local, perfil, sistema, aplicação, ambiente e runtime.
4.3 Servir como filtro primário para Authorization.
4.4 Permitir troca de contexto sem interromper a identidade ou a sessão.
4.5 Garantir que operações subsequentes respeitem o isolamento definido pelo contexto.
4.6 Registrar histórico de contextos utilizados para auditoria.
4.7 Suportar múltiplos contextos simultâneos ou sequenciais por Identity.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Session Runtime | Resolve o contexto inicial após autenticação |
| Portal Enterprise | Permite seleção explícita de contexto pelo usuário |
| Runtime Autorizado | Pode resolver contexto técnico para serviços e APIs |
| Automação / IA | Pode sugerir contexto baseado em perfil e histórico |
| Administração | Pode predefinir contextos padrão por identidade |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Authorization | Aplica permissões diferenciadas por contexto |
| Discovery | Descobre capabilities disponíveis no contexto atual |
| Registry | Filtra módulos e capabilities por contexto |
| Capability | Executa capability restrita ao contexto |
| Runtime | Valida operação dentro do contexto corrente |
| Navigation | Projeta menu baseado no contexto ativo |
| Workflow | Inicia fluxo no contexto operacional correto |
| Event | Registra evento com referência ao contexto |
| Ledger | Registra operação atribuída ao contexto |
| Integration | Valida contexto para chamadas externas |
| Notification | Endereça notificação ao contexto correto |
| IA | Executa sugestões dentro do contexto operacional autorizado |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Context
  │
  ├── 1:1 → Identity (quem está operando)
  │
  ├── 1:1 → Tenant (onde opera)
  │
  ├── 1:1 → Session (em qual sessão está ativo)
  │
  ├── 1:N → Authorization (permissões validadas no contexto)
  │
  ├── 1:N → Event (eventos gerados no contexto)
  │
  ├── 1:N → Ledger (registros imutáveis do contexto)
  │
  └── 1:N → Notification (notificações do contexto)
```

### 7.2 Modelo conceitual

```text
Identity (permanente)
  │
  ├── 1:N → Tenant (vinculo organizacional)
  │         │
  │         ▼
  ├── 1:N → Session (autorização temporária)
              │
              ├── 1:1 → Context (escopo operacional ativo)
              │           │
              │           ├── Unidade
              │           ├── Local
              │           ├── Perfil
              │           ├── Sistema
              │           ├── Aplicação
              │           ├── Ambiente
              │           └── Runtime
              │
              ├── 1:N → Operation
              └── 1:N → Event
```

### 7.3 Múltiplos contextos

```text
Identity: Dra. Ana Silva
  │
  ├── Context A (UPA Centro - Prontuário)
  │     ├── Tenant: Hospital SP
  │     ├── Session: Web
  │     ├── Unidade: UPA Centro
  │     ├── Perfil: Médico
  │     ├── App: Prontuário Eletrônico
  │     └── Runtime: Portal
  │
  ├── Context B (Farmácia - Prescrição)
  │     ├── Tenant: Hospital SP
  │     ├── Session: Mobile
  │     ├── Unidade: Farmácia
  │     ├── Perfil: Prescritor
  │     ├── App: Prescrição Digital
  │     └── Runtime: Mobile
  │
  └── Context C (Ensino - Simulação)
        ├── Tenant: Hospital SP
        ├── Session: Totem
        ├── Unidade: Centro de Simulação
        ├── Perfil: Instrutor
        ├── App: Simulador Clínico
        └── Runtime: Totem
```

Uma mesma Identity pode alternar entre contextos distintos sem recriar sessão ou identidade.

### 7.4 Contexto como filtro de isolamento

```text
Context define:
  - quais unidades são visíveis
  - quais locais são acessíveis
  - quais perfis são aplicáveis
  - quais applications estão disponíveis
  - qual runtime está autorizado
  - qual ambiente está ativo

Nenhuma operação cruza o boundary do contexto
sem autorização explícita.
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Identity | Context pertence a uma Identity |
| Tenant | Context é resolvido dentro de um Tenant |
| Session | Context é o escopo operacional de uma Session |

### 8.2 É dependido por

| Domínio | Como depende de Context |
|---------|--------------------------|
| Authorization | Permissão é validada no contexto corrente |
| Discovery | Discovery resolve capabilities por contexto |
| Registry | Registry filtra por contexto |
| Capability | Capability é executada no contexto |
| Runtime | Runtime valida contexto antes de executar |
| Navigation | Navigation projeta menu por contexto |
| Workflow | Workflow é iniciado por contexto |
| Event | Evento é registrado com referência ao contexto |
| Ledger | Ledger registra operações por contexto |
| Integration | Integration autentica por contexto |
| Notification | Notification é endereçada por contexto |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context |
| ------------ | -------- | ------ | ------- | ------- |
| Identity     | —        |        |         |         |
| Tenant       |          | —      |         |         |
| Session      | ✔        | ✔      | —       |         |
| Context      | ✔        | ✔      | ✔       | —       |
| Authorization| ✔        | ✔      | ✔       | ✔       |
| Discovery    | ✔        | ✔      | ✔       | ✔       |
| Registry     |          |        | ✔       | ✔       |
| Capability   |          |        | ✔       | ✔       |
| Runtime      |          |        | ✔       | ✔       |
| Navigation   |          |        | ✔       | ✔       |
| Workflow     |          |        | ✔       | ✔       |
| Event        |          |        | ✔       | ✔       |
| Ledger       |          |        | ✔       | ✔       |
| Integration  |          |        | ✔       | ✔       |

---

## 9. Estados Canônicos

### 9.1 Estados de Context

| Estado | Descrição |
|--------|-----------|
| RESOLVED | Context foi calculado a partir de atributos válidos |
| ACTIVE | Context está aplicado e operacional |
| SWITCHING | Context está sendo alterado (transição protegida) |
| INVALID | Context contém atributos inválidos ou expirados |
| SUSPENDED | Context foi suspenso temporariamente |
| CLOSED | Context foi encerrado pela sessão |

### 9.2 Regras de transição

```text
RESOLVED → ACTIVE (atributos válidos e contexto aplicado)
ACTIVE → SWITCHING (usuário ou sistema solicitou troca de contexto)
SWITCHING → ACTIVE (novo contexto validado e aplicado)
SWITCHING → INVALID (novo contexto rejeitado)
ACTIVE → SUSPENDED (política de segurança ou administração)
SUSPENDED → ACTIVE (validação administrativa)
ACTIVE → CLOSED (sessão encerrada)
INVALID → RESOLVED (reconstrução do contexto)
```

### 9.3 Regras de negócio

- Context nunca pode ser mais permissivo que a autorização da Session.
- Context nunca pode acessar recursos de outro Tenant.
- A troca de Context (SWITCHING) exige validação atômica.
- Context SUSPENDED bloqueia novas operações, mas mantém a sessão.
- Todo estado de Context deve gerar evento no Ledger.
- Context pode ser explícito (usuário seleciona) ou implícito (sistema resolve).

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Context é a **Foundation Layer** do Kernel.

É o filtro que conecta a autorização temporária (Session) ao escopo real de execução (Authorization, Discovery, Runtime).

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

Context não é uma SP. Context é um conceito.

Sua materialização será:
- Tabelas: `usuario_contexto`, `sessao_contexto_historico`, `runtime_contexto`, `contexto_atendimento`, etc.
- SPs: `sp_auth_contexto_get`, `sp_auth_contexto_set`, `sp_sessao_contexto_get`, `sp_sessao_contexto_set`, `sp_contexto_assert_permissao`, `sp_contexto_assert_transicao`, etc.
- Views: `vw_contexto_active`, `vw_contexto_history`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Context é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Context é construído para uma Identity |
| Tenant | Context opera dentro de um Tenant |
| Session | Context é o escopo operacional de uma Session |
| Authorization | Authorization valida permissões no contexto |
| Discovery | Discovery resolve capabilities por contexto |
| Registry | Registry filtra módulos por contexto |
| Capability | Capability é executada no contexto |
| Runtime | Runtime valida contexto antes de executar |
| Navigation | Navigation projeta menu por contexto |
| Workflow | Workflow é iniciado por contexto |
| Event | Evento é registrado com referência ao contexto |
| Ledger | Ledger registra operações por contexto |
| Integration | Integration autentica por contexto |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza o conceito de escopo operacional.
- Permite troca de perfil/unidade/local sem recriar identidade.
- Torna a autorização contextual e precisa.
- Suporta multi-contexto simultâneo ou sequencial.
- Melhora rastreabilidade com contexto associado a cada operação.
- Reduz complexidade de interfaces: trocar contexto é mais simples que trocar login.

### 11.2 Impactos negativos / Riscos

- Complexidade de resolução: atributos podem conflitar.
- Performance: trocas frequentes de contexto exigem validação eficiente.
- Segurança: contexto inválido pode expor dados de outro escopo.
- Migração: contextos existentes precisam ser mapeados para o novo modelo.
- Auditoria: histórico de contextos cresce rapidamente.

### 11.3 Mitigações

- Validação atômica de contexto (todos os atributos ou nenhum).
- Índices otimizados para consulta de contexto ativo.
- Auditoria obrigatória de toda transição de estado.
- Política de expiração e rotação de contexto.
- Testes de isolamento entre contextos desde o início.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de contexto será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de contexto será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de contexto deve estar coerente com as SPs que a consomem.
12.4 Todo índice de contexto deve suportar as consultas mais frequentes (busca por identity, tenant, session, status).
12.5 Nenhuma operação do Kernel pode existir sem Context resolvido quando houver escopo operacional.
12.6 Toda transição de estado de Context deve gerar evento no Ledger.
12.7 A materialização depende da aprovação do MD-KERNEL-004 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
- MD-KERNEL-001 — Identity
- MD-KERNEL-002 — Tenant
- MD-KERNEL-003 — Session
- MAPA DO KERNEL ENTERPRISE
- MD-KERNEL-DEPENDENCY-MAP
- MD-110 — Canonical Laws
- MD-113 — Lei da Singularidade Canônica
- MD-005 — Lei de Engenharia e Materialização
- MD-034 — Identidade é Permanente, Contexto é Variável
- GATE-DISCOVERY-REGISTRY-RUNTIME-DECISION
- DOSSIER-DISCOVERY-REGISTRY-RUNTIME

---

## 14. Histórico

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-004 — Context |

---

Documento Canônico — MD-KERNEL-004

**Este é o quarto domínio do Kernel Enterprise. Depende de Identity, Tenant e Session, e é pré-requisito para Authorization, Discovery e Runtime.**
