# FRONT-012 — Widget Framework

## Status

Documento Canônico de Frontend.
Define a framework de widgets para dashboards e Portal.

---

## Objetivo

Padronizar a criação, composição e renderização de widgets em toda a plataforma.

---

## Princípio Fundamental

```text
Widget é unidade de informação.
Widget é autônomo.
Widget é permissivo.
Widget é reutilizável.
Widget é configurável.
```

---

## MDs Relacionados

| MD | Finalidade |
|----|-----------|
| MD-043 — Dashboard Framework | Framework de dashboards |
| MD-030 — Enterprise Analytics | Analytics |
| MD-039 — Analytics Data Intelligence | Intelligence |
| MD-085 — Data Lakehouse Platform | Fonte de dados |
| MD-099 — Strategic Command Center | Command Center |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-005 — Dashboard Framework | Experiência de dashboard |
| FRONT-011 — Design System Enterprise | Tokens e componentes |

---

## Arquitetura de Widgets

```
Widget
  ├── Metadados
  │   ├── id_widget
  │   ├── tipo
  │   ├── titulo
  │   ├── descricao
  │   ├── app_origem
  │   ├── perfil_alvo
  │   ├── permissao_requerida
  │   ├── ordem
  │   ├── layout (colunas, altura)
  │   └── refresh_rate
  ├── Dados
  │   ├── sp_origem (ou endpoint API)
  │   ├── parametros
  │   ├── filtros_contexto
  │   └── cache_config
  ├── Visual
  │   ├── componente_canônico
  │   ├── cores
  │   ├── icone
  │   └── tooltip
  └── Comportamento
      ├── loading_state
      ├── error_state
      ├── empty_state
      ├── drill_down_permitido
      └── export_permitido
```

---

## Tipos de Widget Canônicos

| Tipo | Componente | Uso |
|------|-----------|-----|
| KPICard | `KPICard` | Número único com variação e meta |
| ChartLine | `ChartLine` | Série temporal |
| ChartBar | `ChartBar` | Comparativo por categoria |
| ChartPie | `ChartPie` | Proporção/parte de todo |
| ChartArea | `ChartArea` | Volume ao longo do tempo |
| DataTable | `DataTable` | Tabela de dados com ordenação |
| List | `ListWidget` | Lista de itens com ações |
| MapWidget | `MapWidget` | Mapa com pontos/heatmap |
| Gauge | `Gauge` | Medidor de percentual |
| Timeline | `Timeline` | Linha do tempo de eventos |
| FeedWidget | `FeedWidget` | Atividades recentes |
| AlertWidget | `AlertWidget` | Alerta condicional |
| ComparisonCard | `ComparisonCard` | Comparativo período vs. meta |
| RankingList | `RankingList` | Top N itens |

---

## Engine de Widgets

### WidgetRegistry

```text
Catálogo de widgets disponíveis
Filtro por app + perfil + permissão + contexto
Resolução de widget para dashboard
Ordem e layout
Atualização automática quando contexto muda
```

### WidgetLoader

```text
Carregamento lazy de componentes
Code splitting por tipo de widget
Preload de widgets críticos (primeira viewport)
Cache de metadados de widget (5 min)
Invalidation por contexto/permissão
```

### DataResolver

```text
Consulta SP ou API conforme config
Aplica filtros de contexto automaticamente
Respeita permissões de dados
Formata valores conforme locale
Trata erro, vazio e loading
Retorna dados normalizados para o componente visual
```

### CacheManager

```text
Cache por widget + contexto + filtros
TTL configurável por tipo de dashboard
Operacional: 30s
Gerencial: 1h
Estratégico: 24h
Invalidation por evento (preferencial)
Fallback para cache em caso de falha
```

---

## Estados do Widget

### Loading

```text
Skeleton proporcional ao widget:
  - KPICard: 3 linhas
  - Chart: placeholder de gráfico
  - Table: 5 linhas skeleton
  - List: 4 itens skeleton
Duração mínima: 300ms (evita flash)
Transição suave para loaded
```

### Error

```text
Mensagem: "Não foi possível carregar"
Detalhe técnico (apenas desenvolvimento)
Ação: botão "Tentar novamente"
Log automático para Event Store
Não quebra dashboard inteiro
```

### Empty

```text
Mensagem: "Nenhum dado disponível"
Contexto: "para o período selecionado" (se aplicável)
Ação: botão "Atualizar filtros" (se aplicável)
Ilustração amigável (opcional)
```

### NoPermission

```text
Widget invisível (ocupa espaço zero)
Não renderiza espaço vazio
Não cria buraco no layout
Log discreto para auditoria
```

### Success

```text
Renderização conforme tipo
Animações de entrada (stagger)
Interatividade:
  - Hover effects
  - Click para drill-down (se permitido)
  - Tooltips
  - Legendas clicáveis (charts)
```

---

## Layout System

### Grid

```text
CSS Grid nativo
Colunas: 12 colunas base
Gap: var(--space-4)
Responsivo:
  - Mobile: 1 coluna
  - Tablet: 2 colunas
  - Desktop: 3-4 colunas
  - Large: até 6 colunas
```

### Ordenação

```text
Widgets ordenados por campo `ordem`
Drag-and-drop (opcional por plano):
  - Usuário reposiciona widgets
  - Persistência por usuário
  - Reset para default disponível
Responsivo:
  - Ordem diferente por breakpoint (opcional)
```

### Tamanhos

```text
xs: 1 coluna, altura pequena
sm: 2 colunas, altura pequena
md: 2 colunas, altura média (padrão)
lg: 3 colunas, altura média
xl: 4 colunas, altura grande
full: 12 colunas, altura grande (largura total)
```

---

## Interatividade

### Drill-down

```text
Widget com permissão DRILL_DOWN
Click em KPI → abre modal com detalhes
Click em barra do chart → filtra por categoria
Click em linha da tabela → abre detalhe do registro
Respeita permissão do nível inferior
Back button retorna ao dashboard
Registra DRILDOWN_ACESSADO no Event Store
```

### Export

```text
Widget com permissão EXPORT
Tipos: PDF, Excel, CSV, PNG (chart)
Marca d'água: tenant + usuário + timestamp
Log de export no Event Store
Limite de exports por dia (anti-abuse)
```

### Filtros

```text
Filtros globais afetam todos os widgets
Filtros locais (por widget) quando suportado
Filtros de contexto sempre aplicados
Filtros de período (data range picker)
Filtros de comparação (período anterior, meta)
Aplicação em tempo real (debounce 300ms)
Reset de filtros disponível
```

---

## Performance

### Lazy Loading

```text
Widgets fora da viewport não carregam dados.
Intersection Observer detecta visibilidade.
Preload de widgets próximos à viewport.
```

### Memoização

```text
Componentes memoizados por props.
Dados cacheados por widget + contexto.
Evita re-renderizações desnecessárias.
```

### Virtualização

```text
Tabelas com >50 linhas: virtual scroll.
Listas com >100 itens: virtual scroll.
Charts com >1000 pontos: downsampling automático.
```

### Métricas Alvo

```text
Time to First Widget: < 1s
Time to Interactive Dashboard: < 2s
P95 por widget: < 500ms
Cache hit ratio: > 80%
```

---

## Segurança

```text
Dados filtrados por tenant/unidade/local.
Widget sem permissão = oculto.
Export auditado.
Drill-down respeita permissões inferiores.
Dados sensíveis mascarados.
Log de acesso a widget sensível.
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-043 — Dashboard Framework | Framework canônico |
| MD-030 / MD-039 — Analytics | Dados analíticos |
| MD-085 — Data Lakehouse | Fonte de dados grande |
| MD-099 — Strategic Command Center | Dashboard estratégico |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-005 — Dashboard Framework | Experiência de dashboard |
| FRONT-011 — Design System Enterprise | Tokens e visuais |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Widget components, layout, lazy load, cache |
| Backend | APIs de widgets, KPIs, dados |
| Dispatcher | Roteamento para SPs de dashboard |
| SP | Cálculo de KPIs, regras de negócio |
| Event Store | Registrar visualização, drill-down, export |

---

## Métricas

```text
Tipos de widget implementados
Uso por tipo de widget
Tempo de carregamento P95
Taxa de erro por widget
Cache hit ratio
Drill-downs por widget
Exports por widget
Widgets mais usados por perfil
Satisfação com dashboards (CSAT)
```

---

## Lei

```text
Widget é unidade de informação.
Widget é autônomo.
Widget é permissivo.
Widget é reutilizável.
Widget é a alma do Dashboard.
```

---

## Próximo

```text
FRONT-012 completo
  ↓
FRONT-013 — Notification Center
```
