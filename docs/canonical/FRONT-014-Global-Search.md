# FRONT-014 — Global Search

## Status

Documento Canônico de Frontend.
Define a experiência de Busca Global da plataforma.

---

## Objetivo

Tornar a busca o ponto de entrada para toda a inteligência da plataforma.

---

## Princípio Fundamental

```text
Sem busca, conhecimento está preso.
Busca deve ser universal, rápida e relevante.

Busca semântica.
Busca contextual.
Busca conversacional.
```

---

## MDs Relacionados

| MD | Finalidade |
|----|-----------|
| MD-053 — Enterprise Search | Documento canônico de busca |
| MD-087 — Enterprise Search Platform | Plataforma de busca |
| MD-084 — Knowledge Graph | Conhecimento conectado |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | Busca no Portal |
| FRONT-004 — App Registry Navigation | Deep link via busca |

---

## Componentes

### SearchTrigger

```text
Atalho: Cmd+K / Ctrl+K
Barra de busca no header do Portal
Placeholder: "Buscar apps, pessoas, documentos..."
Ícone de busca (lado esquerdo)
Atalho de teclado destacado (lado direito)
Click ou foco: expande SearchOverlay
```

### SearchOverlay

```text
Overlay fullscreen (backdrop blur)
Centralizado, largura máxima 800px
Header: barra de busca grande + botão fechar (ESC)
Subheader: filtros rápidos (abaixo da barra):
  - Todos
  - Apps
  - Documentos
  - Pessoas
  - Chamados
  - Cursos
  - Posts
Corpo: lista de resultados agrupados por tipo
Footer: "Buscar em todo o ecossistema" + créditos IA
```

### SearchResults

```text
Agrupamento por categoria:
  ├── Apps
  │   ├── Ícone + Nome + Descrição
  │   └── Ação: "Abrir"
  ├── Documentos
  │   ├── Ícone + Título + Trecho destacado + data
  │   └── Ação: "Abrir"
  ├── Pessoas
  │   ├── Avatar + Nome + Cargo + Unidade
  │   └── Ação: "Ver perfil" / "Enviar mensagem"
  ├── Chamados
  │   ├── Ícone + Título + Status + data
  │   └── Ação: "Abrir chamado"
  ├── Cursos
  │   ├── Ícone + Título + Progresso
  │   └── Ação: "Continuar"
  ├── Posts
  │   ├── Ícone + Autor + Trecho + data
  │   └── Ação: "Ver post"
  └── Ações Diretas
      ├── "Abrir senha em [Local]"
      ├── "Registrar atendimento"
      └── "Criar chamado"
Cada grupo:
  - Header com nome da categoria + contagem
  - Máximo 5 resultados visíveis
  - "Ver todos em [categoria]" (link)
```

### SearchFilters

```text
Filtros rápidos (chips abaixo da barra):
  - Por app (multi-select)
  - Por tipo de conteúdo
  - Por período
  - Por unidade/local
  - Por autor/criador
Aplicação em tempo real (debounce 200ms)
Remoção individual de filtro
Botão "Limpar filtros"
Persistência de filtros por usuário
```

### SearchActions

```text
Ações diretas na barra de busca:
  - Se app selecionada → navega direto
  - Se documento → preview rápido (modal)
  - Se pessoa → mini-perfil (modal)
  - Se chamado → abre detalaho
  - Se curso → continua de onde parou
Navegação por teclado:
  - ↑↓ para navegar resultados
  - Enter para abrir
  - Tab para ações
  - ESC para fechar
```

### SearchSuggestions

```text
Sugestões ao digitar:
  - "Buscas recentes" (histórico do usuário)
  - "Buscas populares" (trending)
  - "Apps que você usa" (app registry do usuário)
Click em sugestão = busca automática
Remover item do histórico (x)
```

### ConversationalSearch

```text
Modo conversacional: botão "Perguntar à IA"
Interface de chat integrada à busca
Respostas diretas com citação de fonte
Ações sugeridas baseadas na busca
Exemplo:
  Usuário: "Quantos atendimentos hoje?"
  IA: "Hoje foram 47 atendimentos na Unidade São Lucas.
       Quer ver o dashboard operacional?"
  Ações: [Abrir dashboard] [Ver detalhes] [Exportar]
```

---

## Regras

### Permissões

```text
Busca nunca retorna conteúdo sem permissão do usuário.
Resultados são filtrados por tenant + unidade + local + perfil.
Documentos sensíveis aparecem apenas se usuário tem permissão de leitura.
Apps sem permissão são invisíveis nos resultados.
Pessoas de outros tenants não aparecem.
```

### Performance

```text
Sugestões: P95 < 200ms
Busca simples: P95 < 300ms
Busca com filtros: P95 < 500ms
Busca semântica (IA): P95 < 1500ms
Indexação: máximo 5 min de latência
Cache: resultados de busca popular por 10 min
```

### Privacidade

```text
Histórico de busca é privado por usuário.
Histórico não é compartilhado.
Usuário pode limpar histórico.
Busca em conteúdo sensível é auditada.
Nenhuma busca de admin permite ver conteúdo de outro tenant.
```

### Semântica

```text
Sinônimos mapeados (pt-BR):
  - "senha" = "ficha" = "senha de atendimento"
  - "paciente" = "usuário do sistema de saúde"
  - "chamado" = "ticket" = "solicitação"
Contexto-aware:
  - Farmácia: "lote" prioriza resultados de estoque
  - Financeiro: "fatura" prioriza resultados de faturamento
  - RH: "férias" prioriza formulários de RH
Multilíngue: busca funciona em pt-BR, en-US, es-ES
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-053 — Enterprise Search | Documento canônico |
| MD-087 — Enterprise Search Platform | Plataforma de busca |
| MD-084 — Knowledge Graph | Conhecimento conectado |
| MD-081 — AI Copilot Framework | Busca conversacional |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | SearchTrigger no header |
| FRONT-004 — App Registry Navigation | Deep link via busca |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | SearchTrigger, Overlay, Results, Filters, Suggestions |
| Backend | APIs de busca, sugestões, trending, histórico |
| Dispatcher | Roteamento para Search Engine |
| SP | Consultas de busca, filtros, permissões |
| Event Store | Registrar busca, clique, conversão |
| Search Engine | Indexação, ranking, semântica |
| Knowledge Graph | Entidades, relações, sugestões |
| IA | Busca semântica, conversacional, respostas |

---

## Métricas

```text
Buscas por dia
Buscas por usuário/dia
Zero-result rate
Tempo até primeiro resultado (P95)
Taxa de clique em resultado
Taxa de ação direta (abrir, criar)
Buscas com filtro vs. sem filtro
Buscas conversacionais (IA)
Sugestões aceitas
Busca por tipo de conteúdo
Satisfação com busca (CSAT)
```

---

## Lei

```text
Busca não é funcionalidade secundária.
Busca é o ponto de entrada
para toda a inteligência da plataforma.

Sem busca, conhecimento está preso.
```

---

## Próximo

```text
FRONT-014 completo
  ↓
FRONT-015 — Command Center UX
```
