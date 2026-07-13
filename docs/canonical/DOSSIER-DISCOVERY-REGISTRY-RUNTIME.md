# DOSSIER-DISCOVERY-REGISTRY-RUNTIME

## 1. Objetivo

Definir o domínio Discovery + Registry Runtime como parte do Kernel Enterprise da plataforma New Wave.

Este dossiê responde:
- O que é um Module?
- O que é uma Capability?
- O que é um Registry?
- Quem produz?
- Quem consome?
- Como os conceitos se relacionam?
- Qual é o lugar desse domínio dentro do Kernel Enterprise?

Sem mencionar tabelas ou colunas.

---

## 2. Problema que resolve

### 2.1 Problema atual

A plataforma não possui uma camada canônica de descoberta de capacidades.

Hoje o menu é construído por `sp_auth_menu_get`, que:
- Usa `permissao` como fonte de verdade
- Mistura autorização com navegação
- Não distingue módulos de capabilities
- Não há registry de módulos publicáveis
- Não há descoberta dinâmica por tenant

### 2.2 Sintomas

- Para adicionar uma nova capability, é necessário alterar a tabela `permissao`
- O menu é a única fonte de "descoberta"
- Não há forma de saber quais módulos estão disponíveis sem consultar o menu
- Tenants não podem habilitar/desabilitar capabilities independentemente
- O Portal está acoplado à estrutura de permissões

### 2.3 Consequência

A plataforma cresce de forma acoplada. Cada novo produto (HIS, ERP, CRM, BI) precisa hardcodear suas capacidades na tabela `permissao`, criando um modelo que não escala.

---

## 3. Limites do domínio (Boundaries)

### 3.1 Discovery Runtime NÃO é

- **IAM** — não decide identidade, autenticação ou autorização
- **Auth** — não valida senha, token ou sessão
- **Navigation** — não monta menu, não define hierarquia visual
- **Dashboard** — não exibe dados, não renderiza telas
- **Widget** — não é componente visual
- **Portal** — não é frontend
- **Frontend** — não conhece React, não serve API para UI

### 3.2 Discovery Runtime É

Apenas responsável por **descobrir o que existe**.

```text
Dado um contexto autenticado,
quais capacidades existem
e podem ser resolvidas pelo Kernel?
```

### 3.3 Limites claros

```text
┌─────────────────────────────────────────┐
│           PLATFORM ENTERPRISE           │
│                                         │
│  ┌─────────────┐  ┌─────────────────┐  │
│  │   IDENTITY   │  │  AUTHORIZATION  │  │
│  │   Runtime    │  │    Runtime      │  │
│  └──────┬──────┘  └────────┬────────┘  │
│         │                  │            │
│         ▼                  ▼            │
│  ┌─────────────────────────────────┐   │
│  │       CONTEXT / SESSION         │   │
│  └─────────────────────────────────┘   │
│                     │                  │
│                     ▼                  │
│  ┌─────────────────────────────────┐   │
│  │    DISCOVERY + REGISTRY         │   │
│  │         Runtime                 │   │
│  │  (Este dossiê)                  │   │
│  └─────────────────────────────────┘   │
│                     │                  │
│         ┌───────────┼───────────┐     │
│         ▼           ▼           ▼     │
│  ┌───────────┐ ┌───────────┐ ┌──────┐│
│  │  NAVIGATION│ │   PORTAL  │ │ API  ││
│  │  Runtime   │ │  Runtime  │ │      ││
│  └───────────┘ └───────────┘ └──────┘│
│                                         │
└─────────────────────────────────────────┘
```

### 3.4 O que cada camada faz

| Camada | Responsabilidade | Não faz |
|--------|------------------|---------|
| Identity Runtime | Autentica, identifica, emite token | Não autoriza |
| Authorization Runtime | Decide permissão por contexto | Não descobre módulos |
| Context/Session | Gerencia contexto operacional | Não resolve capabilities |
| **Discovery+Registry** | Descobre capabilities por tenant/contexto | Não monta menu, não renderiza |
| Navigation Runtime | Projeta menu a partir de capabilities | Não descobre, não decide |
| Portal Runtime | Renderiza interface | Não resolve capabilities |
| API | Expõe contratos | Não decide negócio |

---

## 4. Conceitos Canônicos

### 4.1 Module

```text
Module é a menor unidade de publicação do Kernel.

Um Module representa um domínio ou subsistema
publicável para consumo interno ou externo.

Exemplos:
  - assistencial
  - farmacia
  - faturamento
  - estoque
  - rh
  - crm
  - bi
```

**Quem publica:** Administração da plataforma / Arquiteto.

**Quem consome:** Discovery Runtime, Registry, Runtime de domínio.

**Ciclo de vida:** Ativo / Inativo / Descontinuado.

---

### 4.2 Capability

```text
Capability é a menor unidade funcional publicável pelo Kernel.

Ela NÃO é:
  - menu
  - permissão
  - tela
  - widget
  - dashboard

Ela representa uma capacidade disponível para execução.

Exemplos:
  - atendimento.iniciar
  - senha.emitir
  - prescricao.criar
  - relatorio.fila
  - dashboard.urgencia
```

**Quem publica:** Administração da plataforma / Desenvolvedor do módulo.

**Quem consome:** Discovery Runtime, Navigation Runtime, API Gateway, IA Agents.

**Ciclo de vida:** Ativo / Inativo / Beta / Descontinuado.

---

### 4.3 Tenant Capability

```text
Tenant Capability é o vínculo entre um Tenant e uma Capability.

Ela representa:
  - se a capability está habilitada para o tenant
  - configurações específicas do tenant para essa capability
  - limites, quotas, features condicionais

Exemplo:
  Tenant: Hospital São Paulo
    → Capability: atendimento.iniciar (HABILITADA)
    → Capability: farmacia.dispensar (HABILITADA)
    → Capability: bi.relatorio_avancado (DESABILITADA)
```

**Quem publica:** Administração do tenant / Arquiteto.

**Quem consome:** Discovery Runtime, Authorization Runtime.

**Ciclo de vida:** Habilitada / Desabilitada / Suspensa.

---

### 4.4 Registry

```text
Registry é o catálogo canônico de entidades da plataforma.

Tipos:
  - Module Registry: catálogo de módulos publicáveis
  - Capability Registry: catálogo de capabilities
  - Tool Registry: catálogo de ferramentas/APIs
  - Agent Registry: catálogo de agentes de IA

O Registry é a fonte de verdade para descoberta.
Nenhuma capability existe sem estar registrada.
```

**Quem publica:** Administração da plataforma.

**Quem consome:** Discovery Runtime, todos os Runtimes, API Gateway.

**Ciclo de vida:** Registrada / Ativa / Depreciada / Removida.

---

## 5. Objetos candidatos

### 5.1 Tabelas

| Objeto | Tipo | Descrição |
|--------|------|-----------|
| `module_registry` | PROPOSE | Registry de módulos publicáveis |
| `capability` | PROPOSE | Catálogo de capabilities |
| `tenant_capability` | PROPOSE | Vínculo tenant × capability |
| `tenant_module` | PROPOSE | Vínculo tenant × módulo |
| `permissao_local` | PROPOSE | Restrição de permissão por local |
| `menu_evento` | PROPOSE | Auditoria de eventos de menu |

### 5.2 Stored Procedures

| Objeto | Tipo | Descrição |
|--------|------|-----------|
| `sp_discovery_capabilities_get` | PROPOSE | Resolve capabilities por contexto autenticado |
| `sp_navigation_menu_get` | PROPOSE | Monta menu dinâmico separada de auth |

### 5.3 Views

| Objeto | Tipo | Descrição |
|--------|------|-----------|
| `vw_usuario_permissoes` | PROPOSE | Consolida permissões do usuário |

### 5.4 Objetos existentes (REUSE)

| Objeto | Tipo | Descrição |
|--------|------|-----------|
| `tenant_registry` | REUSE | Registry de tenants |
| `saas_entidade` | REUSE | Entidade federadora |
| `sistema` | REUSE | Catálogo de sistemas operacionais |
| `usuario_contexto` | REUSE | Snapshot do contexto ativo |
| `runtime_contexto` | REUSE | Estado runtime |

### 5.5 Objetos existentes (ADAPT)

| Objeto | Tipo | Descrição |
|--------|------|-----------|
| `permissao` | ADAPT | Separar auth de menu |
| `perfil_permissao` | ADAPT | Adicionar acao/recurso/ativo |
| `usuario_perfil` | ADAPT | Adicionar id_unidade |

---

## 6. Matriz REUSE / ADAPT / EXTEND / MERGE / PROPOSE

| Objeto | Classificação | Justificativa |
|--------|---------------|---------------|
| `tenant_registry` | REUSE | Já existe, é o registro canônico de tenants. |
| `saas_entidade` | REUSE | Já existe, é a entidade federadora. |
| `sistema` | REUSE | Já existe como catálogo de sistemas. |
| `usuario_contexto` | REUSE | Já existe, snapshot do contexto. |
| `runtime_contexto` | REUSE | Já existe, estado runtime. |
| `permissao` | ADAPT | Existe mas sobrecarregada. Separar auth de menu. |
| `perfil_permissao` | ADAPT | Existe mas faltam colunas. Ampliar. |
| `usuario_perfil` | ADAPT | Existe mas faltam colunas. Ampliar. |
| `module_registry` | PROPOSE | Nova tabela. Registry de módulos. |
| `capability` | PROPOSE | Nova tabela. Capabilities. |
| `tenant_capability` | PROPOSE | Nova tabela. Vínculo tenant × capability. |
| `tenant_module` | PROPOSE | Nova tabela. Vínculo tenant × módulo. |
| `permissao_local` | PROPOSE | Nova tabela. Restrição por local. |
| `menu_evento` | PROPOSE | Nova tabela. Auditoria de menu. |
| `vw_usuario_permissoes` | PROPOSE | Nova view. Permissões do usuário. |
| `sp_discovery_capabilities_get` | PROPOSE | Nova SP. Descoberta de capabilities. |
| `sp_navigation_menu_get` | PROPOSE | Nova SP. Menu dinâmico. |

### 6.1 Por que não EXTEND em `tenant_registry`?

- É um registro de tenants, não de módulos/capabilities.
- Misturar módulos com dados de tenant viola separação de responsabilidades.
- Extender criaria acoplamento inadequado.

### 6.2 Por que não EXTEND em `sistema`?

- É um catálogo de sistemas operacionais (OPE, ASI, HIS, PA, UPA, UBS, FARMACIA, ADMIN).
- Módulos/capabilities são publicados pelo Kernel, não são sistemas operacionais.
- Um módulo pode existir em múltiplos sistemas.
- Estender criaria falsa equivalência.

---

## 7. Modelo conceitual

### 7.1 Visão geral

```text
Platform
  │
  ├── Module
  │     │
  │     ├── Capability
  │     │     │
  │     │     ├── Action
  │     │     │
  │     │     ├── Resource
  │     │     │
  │     │     └── Contract
  │     │
  │     └── Version
  │
  ├── Tenant
  │     │
  │     ├── Tenant Module
  │     │
  │     └── Tenant Capability
  │
  ├── Registry
  │     │
  │     ├── Module Registry
  │     │
  │     ├── Capability Registry
  │     │
  │     └── Tool Registry
  │
  └── Runtime
        │
        ├── Discovery Runtime
        │     │
        │     └── "Dado este contexto, quais capabilities existem?"
        │
        ├── Navigation Runtime
        │     │
        │     └── "Dadas estas capabilities, qual é o menu?"
        │
        └── Portal Runtime
              │
              └── "Dado este menu, como renderizar?"
```

### 7.2 Conceitos primitivos

```text
Module
  - id
  - nome
  - codigo
  - descricao
  - versao
  - dominio
  - estado (ativo/inativo/descontinuado)
  - metadata

Capability
  - id
  - modulo_id
  - codigo
  - nome
  - descricao
  - tipo (SERVICE, UI, REPORT, ACTION, EVENT, API, WORKFLOW, JOB)
  - sp_responsavel
  - contrato
  - estado
  - metadata

Tenant Capability
  - tenant_id
  - capability_id
  - habilitada
  - configuracao_json
  - quota
  - estado

Tenant Module
  - tenant_id
  - module_id
  - habilitado
  - configuracao_json
  - estado
```

### 7.3 Relacionamentos

```text
Tenant
  │
  ├── 1:N → Tenant Module
  │           │
  │           └── N:1 → Module
  │
  └── 1:N → Tenant Capability
              │
              └── N:1 → Capability
                        │
                        └── N:1 → Module
```

---

## 8. Fluxos Runtime

### 8.1 Discovery Runtime

```text
Contexto Autenticado
  │
  ├── tenant_id
  ├── usuario_id
  ├── perfil_id
  ├── unidade_id
  ├── local_id
  │
  ▼
Discovery Runtime
  │
  ├── Consulta Tenant Module (módulos habilitados)
  ├── Consulta Tenant Capability (capabilities habilitadas)
  ├── Filtra por perfil/permissão
  │
  ▼
Capabilities Disponíveis
  │
  └── JSON de capabilities
```

### 8.2 Navigation Runtime

```text
Capabilities Disponíveis
  │
  ├── Agrupa por módulo
  ├── Aplica ordenação
  ├── Aplica visibilidade
  ├── Aplica permissões de navegação
  │
  ▼
Projeção de Menu
  │
  └── JSON de menu
```

### 8.3 Portal Runtime

```text
Projeção de Menu
  │
  ├── Renderiza containers
  ├── Renderiza tiles
  ├── Liga capabilities a telas
  │
  ▼
Interface do Usuário
```

### 8.4 Separação de responsabilidades

```text
Discovery: "O que existe?"
  ↓
Navigation: "Como organizar?"
  ↓
Portal: "Como mostrar?"
```

---

## 9. Integração com o Kernel

### 9.1 Pontos de integração

| Kernel Component | Integração |
|------------------|------------|
| Identity Runtime | Fornece contexto autenticado (tenant, usuário, perfil) |
| Authorization Runtime | Fornece permissões do contexto |
| Context/Session | Fornece unidade, local, sistema |
| Discovery Runtime | Consome Registry + Contexto → Capabilities |
| Navigation Runtime | Consome Capabilities → Menu |
| Portal Runtime | Consome Menu → Interface |
| API Gateway | Consome Discovery → Contratos expostos |
| IA Agents | Consome Discovery → Tools disponíveis |
| Dispatcher | Consome Capability → Master → SP |

### 9.2 Contratos

```text
Discovery Runtime
  │
  ├── Entrada: contexto autenticado
  ├── Saída: capabilities disponíveis
  │
  └── Contrato:
      sp_discovery_capabilities_get(
          p_id_sessao_usuario,
          p_resultado JSON,
          p_sucesso BOOLEAN,
          p_mensagem TEXT
      )
```

---

## 10. Impactos

### 10.1 Impactos positivos

- Separação clara entre descoberta, navegação e interface
- Tenants podem habilitar/desabilitar capabilities independentemente
- Novos módulos não alteram tabelas de permissão
- Discovery dinâmico por contexto
- Plataforma escala para múltiplos produtos (HIS, ERP, CRM, BI, etc.)

### 10.2 Impactos negativos / Riscos

- Criação de novas tabelas e SPs
- Adaptação de tabelas existentes (`permissao`, `perfil_permissao`, `usuario_perfil`)
- Migração de dados existentes
- Mudança de `sp_auth_menu_get` para `sp_navigation_menu_get`
- Necessidade de backward compatibility durante transição

### 10.3 Mitigações

- Manter `sp_auth_menu_get` funcionando durante transição
- Migração idempotente para ADAPT
- Feature flags para novas capabilities
- Documentação completa de call graph

---

## 11. Revisão transversal

### 11.1 Matriz de consumo por domínio

| Domínio     | Usa Module | Usa Capability | Usa Navigation | Usa Discovery |
| ----------- | ---------- | -------------- | -------------- | ------------- |
| HIS         | ?          | ?              | ?              | ?             |
| ERP         | ?          | ?              | ?              | ?             |
| CRM         | ?          | ?              | ?              | ?             |
| BI          | ?          | ?              | ?              | ?             |
| Portal      | ?          | ?              | ?              | ?             |
| Intranet    | ?          | ?              | ?              | ?             |
| Mobile      | ?          | ?              | ?              | ?             |
| API         | ?          | ?              | ?              | ?             |
| Marketplace | ?          | ?              | ?              | ?             |
| Display/TV  | ?          | ?              | ?              | ?             |

### 11.2 Perguntas a responder

1. **HIS**: Precisa de Module Registry? Ou apenas de Capability?
2. **ERP**: Usa Navigation? Ou apenas API?
3. **CRM**: Precisa de Tenant Module? Ou apenas Tenant Capability?
4. **BI**: Consome Discovery? Ou apenas dados brutos?
5. **Portal**: É o único consumidor de Navigation?
6. **Intranet**: Usa Capability? Ou apenas módulos?
7. **Mobile**: Usa Discovery via API?
8. **API**: Expõe capabilities diretamente?
9. **Marketplace**: Registra modules/capabilities externos?
10. **Display/TV**: Consome Navigation? Ou capabilities diretas?

### 11.3 Critério de aprovação

A revisão transversal está APROVADA quando:

1. Todos os domínios estratégicos foram consultados
2. A matriz está preenchida
3. Não há conceitos específicos de um único domínio no Kernel
4. O modelo é suficientemente genérico para todos os domínios
5. A quantidade de tabelas/procedures é mínima mas suficiente

---

## 12. Conclusão

### 12.1 Estado atual

- Auditoria: ✅ Aprovada
- GATE: ✅ Aprovado
- Dossiê: 🟡 Em elaboração
- Revisão transversal: ⏳ Pendente

### 12.2 Próximos passos

1. Aprovar este dossiê
2. Executar revisão transversal
3. Criar Modelo Conceitual (MD-REGISTRY-*)
4. Criar Modelo Lógico
5. Aprovar materialização
6. Gerar SQL
7. Implementar SPs
8. Implementar Backend
9. Implementar Frontend

### 12.3 Decisão

**AGUARDANDO APROVAÇÃO DO DOSSIER E REVISÃO TRANSVERSAL**

Nenhuma materialização (SQL, SP, backend, frontend) será iniciada antes da aprovação deste dossiê e da conclusão da revisão transversal.

---

Documento de Arquitetura — DOSSIER-DISCOVERY-REGISTRY-RUNTIME
