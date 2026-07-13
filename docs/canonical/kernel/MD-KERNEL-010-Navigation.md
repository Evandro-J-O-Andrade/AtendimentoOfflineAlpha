# MD-KERNEL-010 — Navigation

## Status

```text
CANÔNICO (ARQUITETURA)
CICLO 2 — Kernel Enterprise
Runtime Layer
Pré-requisito: MD-KERNEL-000 — Arquitetura Conceitual do Kernel Enterprise
Pré-requisito: MD-KERNEL-006 — Discovery
Pré-requisito: MD-KERNEL-008 — Capability
Pré-requisito: MD-KERNEL-009 — Runtime
Consumido por: MD-KERNEL-014 — Integration
Consumido por: Produtos consumidores (Portal, Apps, Mobile, Display, Totem)
```

---

## 1. Objetivo

Definir o conceito canônico de **Navigation** no Kernel Enterprise.

Navigation é a camada responsável por responder:

> **"Como a realidade resolvida do Kernel é projetada para consumo humano?"**

Ela não é um menu.
Ela não é uma permissão.
Ela é a **camada de projeção** que transforma o estado operacional resolvido pelo Kernel em representações navegáveis para produtos consumidores, sem definir essa realidade.

Navigation apresenta a realidade do Kernel.
Navigation nunca define essa realidade.

Sem Navigation, o Kernel funciona, mas não há interface consumível.
Sem o Kernel, Navigation não tem realidade para projetar.

---

## 2. Definição Canônica

```text
Navigation representa a camada de projeção
do estado operacional resolvido pelo Kernel
para consumo por produtos consumidores.

Navigation é:
  - uma projeção
  - uma representação
  - uma interface de consumo do Kernel
  - dependente de Discovery, Capability e Runtime
  - independente de produto específico
  - sem efeito colateral de execução

Navigation não responde:
  "quem pode acessar?"
  "o que existe?"
  "o que está disponível?"
  "como executar?"

Navigation responde:
  "como apresentar
   a realidade resolvida do Kernel
   para este contexto?"
```

### 2.1 Princípio fundamental

```text
Navigation apresenta a realidade do Kernel.
Navigation nunca define essa realidade.
```

### 2.2 Características obrigatórias

| Característica | Descrição |
|----------------|-----------|
| Projetora | Transforma estado resolvido em representação navegável |
| Dependente | Requer Discovery, Capability e Runtime válidos |
| Leitora | Apenas consulta; não modifica estado operacional |
| Sem efeito colateral | Não cria, altera ou executa operações |
| Multi-formato | Suporta Portal, Mobile, Display, Totem, API |
| Adaptativa | Projeta diferentes representações para diferentes consumidores |
| Auditável | Toda projeção relevante pode ser registrada |
| Extensível | Novos formatos de projeção podem ser adicionados |

### 2.3 Formatos de projeção

| Formato | Natureza | Observação |
|---------|----------|------------|
| Menu | Navegação estruturada | Tree, tabs, drawer, breadcrumb |
| Dashboard | Visão consolidada | Widgets, KPIs, resumos |
| Ação | Comando executável | Botões, atalhos, gestos |
| Lista | Coleção de itens | Tabelas, cards, listas |
| Fluxo | Jornada operacional | Steps, wizard, timeline |
| Estado | Situação corrente | Badges, indicadores, status |

---

## 3. Boundaries

### 3.1 Navigation É

- A camada de projeção do Kernel.
- A transformação de estado resolvido em representação consumível.
- A interface entre o Kernel e os produtos consumidores.
- O mecanismo que evita hardcoding de menus e telas.
- A base para experiência unificada da plataforma.
- O adaptador entre realidade do Kernel e interfaces de consumo.

### 3.2 Navigation NÃO é

- ❌ **Menu fixo**: não define estrutura de navegação permanente.
- ❌ **Permissão**: não decide acesso.
- ❌ **Authorization**: não avalia permissão.
- ❌ **Discovery**: não resolve disponibilidade.
- ❌ **Capability**: não representa capacidade funcional.
- ❌ **Runtime**: não executa operação.
- ❌ **Regra de negócio**: não define fluxos operacionais.
- ❌ **Frontend**: não é implementação de interface; é conceito de projeção.
- ❌ **Produto**: não é Portal, HIS, ERP ou qualquer aplicação.

### 3.3 Limites claros

```text
NAVIGATION
  │
  ├── É responsável por: projeção, representação, adaptação de consumo
  │
  └── NÃO é responsável por:
        ├── identidade (Identity)
        ├── organização (Tenant)
        ├── autenticação (Session)
        ├── escopo operacional (Context)
        ├── decisão de acesso (Authorization)
        ├── catálogo estrutural (Registry)
        ├── descoberta contextual (Discovery)
        ├── capacidade funcional (Capability)
        ├── execução (Runtime)
        └── regra de negócio (Domínio consumidor)
```

---

## 4. Responsabilidades

4.1 Projetar o estado operacional resolvido pelo Kernel em representações navegáveis.
4.2 Adaptar a projeção ao formato do consumidor (Portal, Mobile, Display, Totem, API).
4.3 Manter-se fiel ao estado resolvido; não inventar realidade.
4.4 Suportar múltiplas representações para um mesmo estado.
4.5 Permitir extensão de formatos de projeção.
4.6 Garantir que a projeção não vaza regras de negócio.
4.7 Servir como contrato entre Kernel e produtos consumidores.
4.8 Suportar acessibilidade e localização.

---

## 5. Produtores

| Papel | Responsabilidade |
|-------|------------------|
| Navigation Runtime | Executa a projeção do estado resolvido |
| Administração da Plataforma | Define padrões de projeção |
| Desenvolvedor de Produto | Implementa consumidores de Navigation |
| IA | Analisa padrões de navegação para sugerir otimizações (não decide) |
| Design System | Define componentes de projeção consistentes |

---

## 6. Consumidores

| Consumidor | Como usa |
|------------|----------|
| Portal Enterprise | Consome Navigation para montar workspace e navegação |
| Mobile | Consome Navigation para montar interface móvel |
| Display / TV | Consome Navigation para montar painéis |
| Totem | Consome Navigation para montar interface de autoatendimento |
| APIs | Consome Navigation para expor estado operacional |
| Workflow | Consome Navigation para projetar fluxos ao usuário |
| Integration | Consome Navigation para adaptar integrações |
| IA | Consome Navigation para sugerir ações no contexto correto |
| Analytics | Consome Navigation para entender padrões de uso |

---

## 7. Relacionamentos

### 7.1 Visão geral

```text
Navigation
  │
  ├── Discovery (o que está disponível)
  │
  ├── Capability (o que cada item representa)
  │
  ├── Runtime (estado operacional)
  │
  ├── Context (contexto corrente)
  │
  ├── Authorization (permissões aplicadas)
  │
  ├── 1:N → Product Consumer (Portal, Mobile, Display, Totem, API)
  │
  ├── 1:N → Projection Format (Menu, Dashboard, Ação, Lista, Fluxo, Estado)
  │
  └── 1:N → Event (eventos de projeção)
```

### 7.2 Modelo conceitual

```text
Estado Resolvido do Kernel
  │
  ├── Identity: Dra. Ana Silva
  ├── Tenant: Hospital SP
  ├── Session: Web
  ├── Context: UPA Centro - Médico
  ├── Authorization: PERMITIDO
  ├── Discovery: 12 capabilities disponíveis
  ├── Capability: Atendimento, Prescrição, Exames, ...
  └── Runtime: IDLE
        │
        ▼
  Navigation Engine
        │
        ├── Aplica formato do consumidor (Portal)
        ├── Projeta menu lateral
        ├── Projeta dashboard inicial
        ├── Projeta ações rápidas
        ├── Projeta breadcrumb
        └── Retorna representação estruturada
              │
              ▼
        Portal Enterprise
          ├── Menu lateral
          ├── Dashboard
          ├── Ações rápidas
          └── Breadcrumb
```

### 7.3 Navigation como projeção, não como fonte

```text
PROIBIDO:

Navigation
   ↓
Menu
   ↓
Permissão
   ↓
Autorização

Isso foi um problema histórico.
Menu é projeção, não fonte.

CORRETO:

Capability
      ↓
Authorization
      ↓
Discovery
      ↓
Runtime (estado resolvido)
      ↓
Navigation Projection
      ↓
Portal / Mobile / Display / Totem
```

Navigation é a última camada do Kernel antes dos produtos consumidores.
Ela nunca define a realidade; apenas a projeta.

### 7.4 Separação de conceitos

```text
NAVIGATION
  │
  ├── NÃO é Menu
  │     └── Menu é um formato de projeção de Navigation
  │
  ├── NÃO é Dashboard
  │     └── Dashboard é um formato de projeção de Navigation
  │
  ├── NÃO é Permissão
  │     └── Permissão é decisão de Authorization
  │
  ├── NÃO é Discovery
  │     └── Discovery resolve disponibilidade; Navigation projeta
  │
  ├── NÃO é Runtime
  │     └── Runtime executa; Navigation apresenta
  │
  ├── NÃO é Frontend
  │     └── Frontend é implementação; Navigation é conceito
  │
  └── NÃO é Produto
        └── Produto consome Navigation; Navigation não é produto
```

### 7.5 Multi-formato

```text
Navigation
  │
  ├── Portal (Web)
  │     ├── Menu lateral
  │     ├── Dashboard com widgets
  │     └── Ações em botões
  │
  ├── Mobile
  │     ├── Bottom navigation
  │     ├── Cards
  │     └── Swipe actions
  │
  ├── Display / TV
  │     ├── Grid de informações
  │     ├── Filas grandes
  │     └── Alertas visuais
  │
  ├── Totem
  │     ├── Fluxo passo a passo
  │     ├── Botões grandes
  │     └── Interface touch
  │
  └── API
        ├── JSON estruturado
        ├── HATEOAS
        └── GraphQL
```

Mesmo estado resolvido, diferentes representações para diferentes consumidores.

---

## 8. Dependências

### 8.1 Depende de

| Domínio | Como depende |
|---------|--------------|
| Discovery | Navigation consulta Discovery para disponibilidade |
| Capability | Navigation projeta Capability disponível |
| Runtime | Navigation projeta estado de Runtime |
| Authorization | Navigation aplica permissões de Authorization |
| Context | Navigation aplica contexto operacional |
| Identity | Navigation projeta para uma Identity |
| Tenant | Navigation opera dentro de um Tenant |
| Session | Navigation valida Session ativa |

### 8.2 É dependido por

| Domínio | Como depende de Navigation |
|---------|-----------------------------|
| Portal | Portal consome Navigation para interface |
| Mobile | Mobile consome Navigation para interface |
| Display | Display consome Navigation para painéis |
| Totem | Totem consome Navigation para autoatendimento |
| Integration | Integration consome Navigation para adaptação |
| IA | IA consome Navigation para sugerir ações |

### 8.3 Matriz de dependência

| Domínio      | Identity | Tenant | Session | Context | Authorization | Discovery | Registry | Capability | Runtime | Navigation |
| ------------ | -------- | ------ | ------- | ------- | ------------- | --------- | -------- | ---------- | ------- | ---------- |
| Identity     | —        |        |         |         |               |           |          |            |         |            |
| Tenant       |          | —      |         |         |               |           |          |            |         |            |
| Session      | ✔        | ✔      | —       |         |               |           |          |            |         |            |
| Context      | ✔        | ✔      | ✔       | —       |               |           |          |            |         |            |
| Authorization| ✔        | ✔      | ✔       | ✔       | —             |           |          |            |         |            |
| Discovery    | ✔        | ✔      | ✔       | ✔       | ✔             | —         |          |            |         |            |
| Registry     |          |        |         |         |               | ✔         | —        |            |         |            |
| Capability   |          |        |         |         |               | ✔         | ✔        | —          |         |            |
| Runtime      |          |        |         |         |               | ✔         | ✔        | ✔          | —       |            |
| Navigation   |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       | —          |
| Workflow     |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |            |
| Event        |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |            |
| Ledger       |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |            |
| Integration  |          |        |         |         |               | ✔         | ✔        | ✔          | ✔       |            |

---

## 9. Estados Canônicos

### 9.1 Estados de Navigation

| Estado | Descrição |
|--------|-----------|
| IDLE | Aguardando solicitação de projeção |
| RESOLVING | Processando estado do Kernel para projeção |
| PROJECTED | Projeção concluída com sucesso |
| PARTIAL | Parte do estado não pôde ser projetada |
| EMPTY | Nenhuma capability disponível para projeção |
| ERROR | Falha no processo de projeção |

### 9.2 Regras de transição

```text
IDLE → RESOLVING (solicitação recebida)
RESOLVING → PROJECTED (projeção concluída)
RESOLVING → PARTIAL (parte indisponível)
RESOLVING → EMPTY (nada disponível)
RESOLVING → ERROR (falha)
PROJECTED → IDLE (nova solicitação)
PARTIAL → RESOLVING (nova consulta)
EMPTY → RESOLVING (nova consulta)
ERROR → IDLE (após correção)
```

### 9.3 Regras de negócio

- Navigation é sempre leitura; nunca modifica estado operacional.
- Navigation respeita Discovery; capabilities indisponíveis não são projetadas.
- Navigation respeita Authorization; capabilities negadas não são projetadas.
- Navigation é tenant-aware; nunca projeta conteúdo de outro tenant.
- Navigation pode ser cacheada; invalidação depende de Discovery, Runtime e Context.
- Toda projeção relevante pode gerar evento no Ledger.
- Navigation não expõe metadados sensíveis de capabilities não autorizadas.

---

## 10. Integração com o Kernel

### 10.1 Papel no Kernel

Navigation é a camada final da **Runtime Layer**.

É a projeção que conecta o Kernel aos produtos consumidores, fechando o ciclo operacional.

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
Navigation (apresenta resultado)
  ↓
Produto consumidor (Portal, Mobile, Display, Totem, API)
```

### 10.2 Contratos

Navigation não é uma SP. Navigation é um conceito.

Sua materialização será:
- Tabelas: `navigation_projection`, `navigation_format`, `navigation_history`, etc.
- SPs: `sp_navigation_project`, `sp_navigation_query`, `sp_navigation_invalidate`, etc.
- Views: `vw_navigation_active`, `vw_navigation_by_consumer`, etc.

Mas esses detalhes pertencem ao **Modelo Lógico** e **Modelo Físico**.

Neste documento, Navigation é apenas um conceito.

### 10.3 Integração com outros domínios

| Domínio | Integração |
|---------|------------|
| Identity | Navigation projeta para uma Identity |
| Tenant | Navigation opera dentro de um Tenant |
| Session | Navigation valida Session ativa |
| Context | Navigation aplica Context resolvido |
| Authorization | Navigation aplica permissões de Authorization |
| Discovery | Navigation consulta Discovery para disponibilidade |
| Registry | Navigation consulta Registry para estrutura |
| Capability | Navigation projeta Capability disponível |
| Runtime | Navigation projeta estado de Runtime |
| Workflow | Navigation projeta fluxos de Workflow |
| Event | Evento registra projeções relevantes |
| Ledger | Ledger persiste histórico de projeções |
| Integration | Integration consome Navigation para adaptação |

---

## 11. Impacto Arquitetural

### 11.1 Impactos positivos

- Centraliza a projeção de navegação em um ponto único.
- Torna a experiência consistente entre produtos.
- Elimina hardcoding de menus e telas.
- Suporta multi-tenant e multi-consumidor naturalmente.
- Permite evolução de projeções sem alterar o Kernel.
- Cria base para experiência unificada da plataforma.
- Separa claramente realidade de representação.

### 11.2 Impactos negativos / Riscos

- Complexidade de projeção: múltiplos formatos e consumidores.
- Performance: projeção é consultada em toda navegação.
- Cache inválido: mudança de estado sem invalidação projeta realidade obsoleta.
- Migração: produtos legados precisam migrar de menu hardcoded para Navigation.
- Governança: projeções sem dono poluem o catálogo.

### 11.3 Mitigações

- Motor de projeção otimizado com índices adequados.
- Política de invalidação de cache atrelada a Discovery e Runtime.
- Padrões de projeção documentados por formato.
- Migração gradual por produto.
- Dashboard de health de Navigation por tenant.

---

## 12. Critérios de Materialização

12.1 Nenhuma tabela de navigation será criada sem justificar REUSE/ADAPT/EXTEND/MERGE/PROPOSE.
12.2 Nenhuma SP de navigation será criada sem classificação de tipo (MASTER, DISPATCHER, ORCHESTRATOR, EXECUTOR, ASSERT, QUERY, COMMAND, LEDGER, EVENT).
12.3 Toda FK de navigation deve estar coerente com as SPs que a consomem.
12.4 Todo índice de navigation deve suportar as consultas mais frequentes (busca por identity, tenant, contexto, formato).
12.5 Nenhuma projeção de Navigation pode existir sem estado resolvido do Kernel.
12.6 Toda projeção de Navigation deve gerar evento no Ledger quando relevante.
12.7 Navigation nunca modifica estado operacional; é puramente consulta e representação.
12.8 Navigation é a única camada autorizada a projetar estado do Kernel para consumidores.
12.9 A materialização depende da aprovação do MD-KERNEL-010 e do dossiê correspondente.

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
- MD-KERNEL-008 — Capability
- MD-KERNEL-009 — Runtime
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
| 1.0 | 2026-07-13 | Kilo | Criação do MD-KERNEL-010 — Navigation |

---

Documento Canônico — MD-KERNEL-010

**Este é o décimo domínio do Kernel Enterprise. Pertence à Runtime Layer, depende de Discovery, Capability e Runtime, e é pré-requisito para Integration e produtos consumidores.**
