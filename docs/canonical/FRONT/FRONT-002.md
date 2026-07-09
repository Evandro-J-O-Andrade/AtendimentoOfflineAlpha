# FRONT-002 — Canonical Context Selection Experience

> **Status:** Canônico  
> **Domínio:** FRONT  
> **Tipo:** Experiência de Seleção de Contexto  
> **Companheiro:** FRONT-000 (Constituição), FRONT-001 (Login), MD-120 (Party Identity Architecture), MD-124 (Context First Architecture), MD-108 (Operational Context Engine), MAP-001 (Enterprise Domain Architecture)

---

## 1. Objetivo

Define a experiência canônica de seleção de contexto da plataforma SaaS Enterprise.

A Context Selection Experience implementa a lei fundamental:

```text
Identidade != Contexto
```

Nenhuma aplicação de domínio (HIS, Workforce, Displays, Financeiro etc.) pode ser carregada antes da resolução do contexto ativo. O contexto é o contrato que habilita o acesso operacional.

Fluxo canônico:

```text
Pessoa
    ↓
Identity
    ↓
Contexto
    ↓
Portal Enterprise
    ↓
Aplicações
```

Nunca:

```text
Login
    ↓
HIS
```

Nenhuma aplicação quebra essa ordem (MD-CANONICO-IA-001 Regra 21).

---

## 2. Escopo

A Context Selection Experience é responsável apenas por:

- descobrir contextos disponíveis para a pessoa autenticada;
- apresentar os contextos disponíveis;
- permitir a seleção de um contexto ativo;
- propagar o contexto selecionado para o Portal Runtime.

A Context Selection Experience **não**:

- autentica usuários;
- resolve permissões diretamente;
- conhece aplicações de domínio;
- conhece HIS, Workforce, Displays, Financeiro ou qualquer módulo de negócio;
- persiste dados;
- acessa banco diretamente;

Qualquer violação desse escopo é bloqueada pela governança arquitetural.

---

## 3. Fluxo Canônico

```text
/auth/session (SessionResolver)
    ↓
AuthSessionContract
    ↓
ContextResolver
    ↓
ContextResolutionResult
    ↓
status == CONTEXT_SELECTION_REQUIRED?
    │
    ├── NÃO ──► Contexto único / já selecionado
    │              ↓
    │         PortalRuntimeEngine
    │              ↓
    │         PortalRuntimeContract
    │              ↓
    │         Portal Enterprise
    │
    └── SIM ──► Context Selection Experience
                    ↓
               available: ContextContract[]
                    ↓
               Usuário seleciona contexto
                    ↓
               ContextSelectionContract
                    ↓
               ContextResolver (com chosenContextId)
                    ↓
               status == ACTIVE
                    ↓
               PortalRuntimeEngine
                    ↓
               PortalRuntimeContract
                    ↓
               Portal Enterprise
```

Regras do fluxo:

- A descoberta de contextos é feita exclusivamente por `ContextResolver`.
- Nenhuma regra de permissão é aplicada na Context Selection Experience.
- Nenhum catálogo de aplicações é carregado na Context Selection Experience.
- Nenhum widget é carregado na Context Selection Experience.
- A seleção de contexto é um ato de navegação, não de configuração.

---

## 4. O que é Contexto

### 4.1 Hierarquia Canônica

```text
Pessoa      → Identidade global (raiz)
Tenant      → Organização / cliente
Unidade     → Unidade física ou operacional do Tenant
Contexto    → Unidade operacional ativa dentro da Unidade
```

### 4.2 Exemplo

```text
Pessoa:     João Silva
Tenant:     Hospital Central
Unidade:    Matriz
Contexto:   Pronto Atendimento Adulto
```

### 4.3 Regras

- Uma Pessoa pode pertencer a múltiplos Tenants.
- Um Tenant pode possuir múltiplas Unidades.
- Uma Unidade pode possuir múltiplos Contextos.
- Uma Pessoa pode ter acesso a múltiplos Contextos.
- O Contexto ativo determina o escopo operacional das aplicações.

Essa hierarquia é resolvida pelo `ContextResolver` em `packages/runtime`.

---

## 5. Context Resolution Matrix

Matriz de referência para implementação e testes:

| Sessão            | Contextos disponíveis | Resultado                      |
| ----------------- | --------------------- | ------------------------------ |
| Não autenticado   | —                     | `/login`                       |
| Autenticado       | 0                     | `NO_CONTEXT`                   |
| Autenticado       | 1                     | Seleção automática e `/portal` |
| Autenticado       | >1                    | `/context`                     |
| Contexto inválido | —                     | `ERROR`                        |
| Contexto expirado | —                     | Nova seleção de contexto       |

Nenhuma combinação fora dessa matriz é permitida.

---

## 6. Estados

A Context Selection Experience possui os seguintes estados canônicos:

```text
LOADING_CONTEXTS
NO_CONTEXT
SINGLE_CONTEXT
MULTIPLE_CONTEXTS
CONTEXT_SELECTED
ERROR
```

Transições válidas:

```text
LOADING_CONTEXTS
    ↓ (sucesso / 1 contexto)
SINGLE_CONTEXT
    ↓ (auto-seleção)
CONTEXT_SELECTED
    ↓ (sucesso / múltiplos contextos)
MULTIPLE_CONTEXTS
    ↓ (seleção do usuário)
CONTEXT_SELECTED
    ↓ (falha na descoberta)
ERROR
    ↓ (nenhum contexto disponível)
NO_CONTEXT
```

Nenhum estado pode ser omitido ou substituído por valores ad-hoc.

---

## 7. Eventos

Eventos padronizados emitidos pela Context Selection Experience:

```text
CONTEXT_DISCOVERY_STARTED
CONTEXT_DISCOVERY_COMPLETED
CONTEXT_SELECTED
CONTEXT_CHANGED
CONTEXT_CLEARED
```

Esses eventos são publicados no barramento de eventos da plataforma e estarão disponíveis para integração futura com o Event Store.

Nenhum evento específico de domínio (ex.: `HIS_CONTEXT_SELECTED`) pode ser criado na Context Selection Experience.

---

## 8. Contratos

Todos os tipos são exclusivos de `packages/contracts`. Nenhum tipo pode ser declarado dentro da `ContextSelectionPage` ou de componentes da Context Selection Experience.

### 8.1 Contratos existentes (consumidos)

```typescript
PersonContract
TenantContract
ContextContract
AuthSessionContract
```

Local: `packages/contracts/src/identity/`, `packages/contracts/src/tenant/`, `packages/contracts/src/context/`, `packages/contracts/src/auth/`

### 8.2 Contratos existentes (produzidos pelo Runtime)

```typescript
ContextResolutionResult
ContextResolutionStatus
```

Local: `packages/runtime/src/contracts/RuntimeContracts.ts`

### 8.3 Contratos novos (criar em `packages/contracts/src/context/`)

```typescript
ContextSelectionContract
```

Definição conceitual — implementação exata fica a cargo da criação dos contratos:

```typescript
interface ContextSelectionContract {
  selectedContext: ContextContract | null
  availableContexts: ContextContract[]
  defaultContext: ContextContract | null
}
```

---

## 9. Runtime

O Runtime (`packages/runtime`) é a camada que resolve o contexto.

Fluxo:

```text
AuthProvider
    ↓
SessionResolver
    ↓
AuthSessionContract
    ↓
ContextResolver
    ↓
ContextResolutionResult
    ↓
PortalRuntimeEngine
    ↓
PortalRuntimeContract
    ↓
Portal Enterprise
```

A Context Selection Experience **não** invoca `PortalRuntimeEngine` diretamente. O consumo do runtime é responsabilidade do `PortalRuntimeProvider`, conforme arquitetura canônica.

Regra: o Runtime não acessa banco, não chama Stored Procedures e não conhece módulos de domínio.

---

## 10. API

Toda comunicação de contexto passa por `packages/api`. Nunca `fetch()`/`axios()` espalhado nas telas.

Contratos esperados pela camada `packages/api`:

```text
GET /context/available
    Return: ContextContract[]

POST /context/select
    Body: { contextId: string }
    Return: ContextSelectionContract

GET /context/active
    Return: ContextContract | null
```

Nenhuma referência a Stored Procedures pode aparecer em `packages/api` ou na Context Selection Experience.

---

## 11. UX

Requisitos mínimos não-negociáveis:

- tela limpa e sem distrações;
- branding por Tenant;
- suporte a temas (`light` | `dark` | `tenant`);
- loading durante descoberta de contextos;
- mensagens de erro padronizadas;
- acessibilidade (navegação por teclado, leitores de tela);
- responsividade;
- indicação clara do Tenant e Unidade antes da seleção do Contexto.

Não são definidos layout fixo, tipografia específica ou componentes visuais herdados. A implementação visual segue o guia de experiência canônico FRONT-000.

Importante: a tela **não** exibe aplicações, permissões ou módulos de negócio. Ela apresenta apenas contextos operacionais.

---

## 12. Critérios de Aceitação

A Context Selection Experience é aprovada somente quando:

- contextos são descobertos automaticamente após autenticação;
- um único contexto é selecionado automaticamente, sem intervenção do usuário;
- múltiplos contextos exigem seleção explícita do usuário;
- nenhum token é armazenado no frontend;
- nenhuma regra de permissão é aplicada na seleção de contexto;
- permissões são avaliadas somente após a seleção do contexto ativo;
- todas as regras de negócio permanecem no backend ou no Runtime;
- a implementação respeita os estados canônicos;
- todos os tipos vêm de `packages/contracts`;
- a experiência não bloqueia o fluxo canônico.

---

## 13. Critérios de Rejeição

O KILO rejeita implementações que:

- escolham aplicações antes do contexto;
- misturem Tenant com Pessoa;
- tratem Unidade como Tenant;
- acessem banco diretamente;
- chamem Stored Procedures do frontend;
- implementem permissões na Context Selection Experience;
- redirecionem diretamente para HIS ou qualquer módulo de domínio;
- declarem tipos dentro da `ContextSelectionPage` ou de componentes da Context Selection Experience;
- ignorem `packages/api` e chamem `fetch()`/`axios()` diretamente;
- utilizem eventos específicos de domínio;
- criem estruturas de navegação baseadas em cargo, função, perfil ou setor como diretórios físicos (`workspaces/medico`, `workspaces/recepcao`, etc.).

---

## 14. Dependências

### Permitidas

```text
packages/contracts
packages/api
packages/auth
packages/runtime
```

### Proibidas

```text
apps/his
apps/workforce
apps/displays
apps/management
apps/financeiro
database/
modules/
```

---

## 15. Regra Permanente

```text
Nenhuma página React pode ser criada sem um FRONT correspondente aprovado.

Página              Documento obrigatório

LoginPage           FRONT-001
ContextSelection    FRONT-002
PortalPage          FRONT-003
ApplicationLauncher FRONT-004
DashboardPage       FRONT-005
```

Essa regra impede crescimento desorganizado da base de código.

---

## 16. ADR de Referência

### ADR-007 — Context Resolution Rule

```text
Identidade nunca determina contexto.

Contexto nunca determina identidade.

O Runtime resolve o contexto ativo.

Aplicações dependem do contexto ativo.

Permissões são avaliadas dentro do contexto.
```

Essa ADR complementa ADR-006 (Database Evolution) e reforça uma das leis mais importantes do projeto.

---

## Integrações

| FRONT / MD | Finalidade |
|---|
| FRONT-000 — Frontend Platform Architecture Constitution | Constituição |
| FRONT-001 — Canonical Login Experience | Autenticação |
| MD-020 — Portal Core | Núcleo do Portal |
| MD-108 — Operational Context Engine | Motor de contexto |
| MD-120 — Party Identity Architecture | Identidade |
| MD-124 — Context First Architecture | Contexto primeiro |
| MAP-001 — Enterprise Domain Architecture | Domínios |
| FRONT-003 — Portal Enterprise Experience | Experiência do Portal |

---

*Última atualização: 2026-07-07*
