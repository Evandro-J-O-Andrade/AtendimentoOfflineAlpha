# MD-KERNEL-001 — Identity

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Foundation Layer
Pré-requisito: MD-KERNEL-000
```

---

## 1. Objetivo

Definir o conceito canônico de **Identity** no Kernel Enterprise.

Identity é a camada responsável por responder:

> **"Quem existe dentro da plataforma?"**

Ela não é apenas "usuário de sistema".
Ela é a raiz de toda a identidade: pessoa, usuário, serviço, API, terminal, display, agente, identidade técnica.

Todo o resto do Kernel depende de Identity.

---

## 2. Definição Canônica

```text
Identity é o conceito que representa uma entidade identificável
dentro da plataforma New Wave Enterprise.

Uma Identity pode ser:
  - uma pessoa física
  - um usuário operacional
  - um serviço técnico
  - uma API
  - um terminal/dispositivo
  - um display
  - um agente de IA
  - uma identidade técnica (integração)

Identity é permanente.
Identity é única.
Identity é independente de contexto.
```

### 2.1 Princípio fundamental

```text
Pessoa é a entidade raiz.
Usuário é uma projeção operacional de uma Pessoa.
Serviço, API, Terminal, Display e Agente
são identidades não-pessoa.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Permanente | Identity não é criada nem destruída por contexto |
| Única | Não existem duas identities com o mesmo identificador canônico |
| Independente | Identity existe antes de qualquer sessão, tenant ou contexto |
| Auditável | Toda criação, alteração de status e vínculo é registrado |
| Multi-tenant | Uma pessoa pode existir em múltiplos tenants simultaneamente |

---

## 3. Boundaries

### 3.1 Identity É

- A raiz de toda a existência na plataforma.
- O ponto de partida para sessão, contexto, autorização e runtime.
- O conceito que responde "quem está operando".
- A entidade que recebe permissões, papéis e vínculos.

### 3.2 Identity NÃO é

- ❌ **Auth**: não valida senha, token ou sessão.
- ❌ **Session**: não representa uma sessão ativa.
- ❌ **Context**: não carrega unidade, local ou perfil operacional.
- ❌ **Authorization**: não decide permissões.
- ❌ **Tenant**: não representa uma empresa ou entidade.
- ❌ **Pessoa física apenas**: também cobre serviços, APIs, terminais, displays, agentes.
- ❌ **Frontend**: não exibe nada.
- ❌ **Banco**: é um conceito, não uma tabela.

### 3.3 Limites claros

```text
IDENTITY
  │
  ├── É responsável por: existência, identificação, tipo, status
  │
  └── NÃO é responsável por:
        ├── autenticação (Auth)
        ├── sessão (Session)
        ├── contexto operacional (Context)
        ├── permissões (Authorization)
        ├── execução (Runtime)
        └── interface (Portal/Frontend)
```

---

## 4. Responsabilidades

4.1 Manter o catálogo canônico de todas as entidades identificáveis da plataforma.
4.2 Garantir unicidade de identificação.
4.3 Permitir vínculos entre identities (pessoa ↔ usuário, usuário ↔ serviço, etc.).
4.4 Suportar múltiplos tenants para a mesma pessoa.
4.5 Fornecer a base para Auth, Session, Context e Authorization.
4.6 Manter histórico de identidades (criação, desativação, reativação).
4.7 Permitir classificação por tipo (pessoa, usuário, serviço, API, terminal, display, agente).

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Administração da Plataforma | Cria e gerencia identidades técnicas (serviços, APIs, terminais, displays, agentes) |
| Sistema de Cadastro | Cria pessoas físicas e usuários operacionais |
| Auto-cadastro | Pessoa física pode criar própria identidade (quando habilitado) |
| Integração | Sistemas externos podem solicitar criação de identity via API autorizada |
| IA | Agentes de IA são identities criadas pelo Kernel (não por si mesmos) |

---

## 6. Consumidores

| Consumidor | Como usa |
|-------------|----------|
| Auth Runtime | Valida identidade na autenticação |
| Session Runtime | Cria sessão vinculada a uma identity |
| Context Runtime | Resolve contexto operacional de uma identity |
| Authorization Runtime | Aplica permissões por identity |
| Discovery Runtime | Descobre capabilities disponíveis para uma identity |
| Navigation Runtime | Projeta menu baseado em identity |
| Runtime | Executa operações em nome de uma identity |
| Ledger | Registra eventos atribuídos a uma identity |
| Notification | Endereça notificações a uma identity |
| Integration | Autentica chamadas de APIs externas |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Identity
  │
  ├── 1:N → Session
  │
  ├── 1:N → Context
  │
  ├── 1:N → Tenant (via vínculo pessoa-tenant)
  │
  ├── 1:N → Authorization (permissões diretas ou via perfil)
  │
  ├── 1:N → Ledger (eventos gerados)
  │
  └── 1:N → Notification (notificações recebidas)
```

### 7.2 Tipos de Identity

```text
Identity
  │
  ├── Pessoa Física
  │     │
  │     └── Usuário Operacional (projeção com credenciais)
  │
  ├── Serviço Técnico
  │     │
  │     └── API Key / Service Account
  │
  ├── Terminal
  │     │
  │     └── Dispositivo / Kiosk / Display
  │
  └── Agente
        │
        └── IA / Automação / Bot
```

### 7.3 Pessoa como raiz

```text
Pessoa
  │
  ├── Usuário (credenciais, perfil operacional)
  │
  ├── Vínculo Tenant (em quais empresas existe)
  │
  ├── Vínculo Unidade (em quais unidades opera)
  │
  ├── Vínculo Perfil (quais perfis assume)
  │
  └── Histórico (eventos, acessos, evoluções)
```

### 7.4 Usuário como projeção

```text
Usuário
  │
  ├── Credenciais (senha, token, MFA)
  │
  ├── Status (ativo, inativo, bloqueado)
  │
  ├── Vínculos (unidades, locais, perfis)
  │
  └── Preferências (idioma, tema, notificações)
```

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Nenhum | Identity é o primeiro domínio do Kernel |

### 8.2 É dependido por

| Domínio | Como depende de Identity |
|---------|--------------------------|
| Tenant | Pessoa pertence a tenant |
| Session | Sessão pertence a identity |
| Context | Contexto pertence a identity |
| Authorization | Permissão pertence a identity |
| Discovery | Discovery resolve capabilities para identity |
| Registry | Registry referencia identities |
| Capability | Capability é atribuída a identity |
| Runtime | Runtime executa em nome de identity |
| Navigation | Navigation projeta menu para identity |
| Workflow | Workflow é iniciado por identity |
| Event | Evento é gerado por identity |
| Ledger | Ledger registra identity |
| Integration | Integration autentica identity |

### 8.3 Matriz de dependência

| Domínio      | Identity |
| ------------ | -------- |
| Identity     | —        |
| Tenant       |          |
| Session      | ✔        |
| Context      | ✔        |
| Authorization| ✔        |
| Discovery    | ✔        |
| Registry     | ✔        |
| Capability   | ✔        |
| Runtime      | ✔        |
| Navigation   | ✔        |
| Workflow     | ✔        |
| Event        | ✔        |
| Ledger       | ✔        |
| Integration  | ✔        |

---

## 9. Estados Canônicos

### 9.1 Estados de Identity

| Estado | Descrição |
|--------|-----------|
| ATIVO | Identity está operacional |
| INATIVO | Identity foi desativada (soft delete) |
| BLOQUEADO | Identity está bloqueada temporariamente |
| PENDENTE | Identity aguarda validação (ex: e-mail não confirmado) |
| SUSPENSO | Identity suspensa por decisão administrativa |

### 9.2 Regras de transição

```text
PENDENTE → ATIVO (validação concluída)
ATIVO → INATIVO (desativação)
ATIVO → BLOQUEADO (bloqueio temporário)
BLOQUEADO → ATIVO (desbloqueio)
INATIVO → ATIVO (reativação)
ATIVO → SUSPENSO (suspensão administrativa)
SUSPENSO → ATIVO (remoção da suspensão)
```

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Identity é a **Foundation Layer** do Kernel.

Toda operação na plataforma começa por uma identity.

```text
Cliente
  ↓
Identity (quem é?)
  ↓
Session (onde está?)
  ↓
Context (o que pode?)
  ↓
Authorization (pode?)
  ↓
Runtime (executa)
```

### 10.2 Contratos

Identity não é uma SP. Identity é um conceito.

Sua materialização será:
- Tabelas: `pessoa`, `usuario`, `identidade_tecnica`, etc.
- SPs: `sp_identity_get`, `sp_identity_create`, `sp_identity_update`, etc.
- Views: `vw_identity_summary`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Identity é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Session | Session referencia Identity |
| Context | Context referencia Identity |
| Authorization | Authorization referencia Identity |
| Discovery | Discovery filtra por Identity |
| Registry | Registry pode ser consultado por Identity |
| Capability | Capability pode ser atribuída a Identity |
| Runtime | Runtime executa em nome de Identity |
| Navigation | Navigation projeta menu para Identity |
| Workflow | Workflow é iniciado por Identity |
| Event | Evento é gerado por Identity |
| Ledger | Ledger registra Identity |
| Integration | Integration autentica Identity |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza a raiz de toda a identidade.
- Evita duplicação de conceitos de usuário/pessoa.
- Permite multi-tenancy desde a fundação.
- Suporta identidades não-pessoa (serviços, APIs, terminais, displays, agentes).
- Fornece base sólida para Auth, Session, Context e Authorization.

### 11.2 Impactos negativos / Riscos

- Complexidade inicial: modelo de identity é mais rico que um simples `usuario`.
- Curva de aprendizado: equipe precisa entender a distinção Pessoa × Usuário × Identity.
- Migração: dados existentes de `usuario` precisam ser mapeados para o novo modelo.
- Performance: consultas de identity precisam ser otimizadas desde o início.

### 11.3 Mitigações

- Documentação clara com exemplos.
- Migração idempotente.
- Views de compatibilidade durante transição.
- Testes de integração desde o início.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de identity será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de identity será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de identity deve estar coerente com as SPs que a consomem.
12.4 Todo índice de identity deve suportar as consultas mais frequentes.
12.5 Nenhum conceito de identity pode ser hardcoded no frontend.
12.6 Toda operação de identity deve gerar evento no Ledger.
12.7 A materialização depende da aprovação do MD-KERNEL-001 e do dossiê correspondente.

---

## 13. Referências

- MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
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
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-001 — Identity |

---

Documento Canônico — MD-KERNEL-001

**Este é o primeiro domínio do Kernel Enterprise. Todo o resto depende dele.**
