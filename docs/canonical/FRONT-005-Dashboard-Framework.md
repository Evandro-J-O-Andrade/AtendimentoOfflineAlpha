# FRONT-005 — Dashboard Framework

## Status

Documento Canônico de Frontend.
Define como dashboards são construídos, compostos e entregues.

---

## Objetivo

Garantir que dashboards sejam contextuais, permissivos e dinâmicos.

---

## Princípio Fundamental

```text
Dashboard não pertence à aplicação.
Dashboard pertence ao contexto.

Dashboard =
  App
+ Perfil
+ Permissão
+ Contexto Operacional
```

---

## Lei Suprema

```text
Dois usuários na mesma App
nunca veem o mesmo Dashboard,
a menos que tenham
exatamente o mesmo Perfil,
Permissão e Contexto.
```

---

## Componentes

### DashboardEngine

```text
Recebe: app, perfil, permissões, contexto
Consulta: widgets configurados para app+perfil+contexto
Resolve: dados via SP canônica ou API Analytics
Formata: valores, datas, moedas conforme locale
Retorna: dashboard pronto para renderização
```

### WidgetComposer

```text
Renderiza widget conforme tipo (KPI, Chart, Table, List, Map, Gauge, Timeline, Feed, Alert)
Respeita permissão do widget
Aplica filtros de contexto
Gerencia loading, erro e empty state
Suporta drill-down (se permitido)
Suporta export (se permitido)
```

### KPIEngine

```text
Calcula KPIs via SP ou API Analytics
Aplica fórmulas canônicas
Respeita contexto (tenant/unidade/local)
Formata valores (moeda, porcentagem, inteiro)
Aplica meta e comparação (vs. período anterior, vs. meta)
```

### FilterBar

```text
Filtros globais do dashboard
Período (data início, data fim)
Unidade (se agregado permitido)
Local (se agregado permitido)
Comparativo (período anterior, meta)
Aplicação de filtro em tempo real
```

### ExportPanel

```text
Export em PDF, Excel, CSV
Apenas se permissão EXPLICITAMENTE concedida
Marca d'água do tenant
Log de export no Event Store
```

---

## Tipos de Dashboard

### Operacional

```text
Uso: dia a dia do operador
Público: Recepcionista, Enfermeiro, Médico, Farmacêutico, Caixa
Atualização: Tempo real ou near-real-time (30s)
Conteúdo: filas, senhas, atendimentos em andamento, métricas de processo
Exemplos:
  - Dashboard de Fila
  - Dashboard de Farmácia
  - Dashboard de PDV
```

### Gerencial

```text
Uso: gestão e decisão
Público: Gerente, Diretor, Coordenador
Atualização: Hora a hora ou diária
Conteúdo: KPIs, metas, comparativos, tendências
Exemplos:
  - Dashboard de Gerente de Farmácia
  - Dashboard de Diretor Financeiro
```

### Estratégico (Command Center)

```text
Uso: visão de negócio e estratégia
Público: C-Level, Conselho, Investidores
Atualização: Diária ou semanal
Conteúdo: MRR, ARR, churn, pipeline, market share
Exemplos:
  - Dashboard Executivo (MD-099)
  - Dashboard de Tenant (uso da plataforma, ROI)
```

---

## Widgets

### Tipos Canônicos

| Tipo | Uso | Exemplo |
|------|-----|---------|
| KPICard | Número com meta e variação | Faturamento do dia |
| Chart | Gráfico (linha, barra, pizza, área) | Vendas por mês |
| Table | Tabela com ordenação e filtro | Atendimentos do dia |
| List | Lista de itens com ações | Chamados abertos |
| Map | Mapa geográfico | Unidades, clientes |
| Gauge | Medidor de performance | SLA do dia |
| Timeline | Linha do tempo de eventos | Evolução do paciente |
| Feed | Feed de atividades | Atendimentos recentes |
| Alert | Alerta condicional | SLA vencendo, estoque crítico |

### Composição Canônica

```text
Widget =
  id_widget
+ tipo
+ titulo
+ descricao
+ app_origem
+ perfil_alvo
+ permissao_requerida
+ sp_origem (ou endpoint API)
+ parametros (filtros de contexto)
+ ordem
+ layout (grid, tamanho, colunas)
+ refresh_rate
+ drill_down_permitido
+ export_permitido
```

---

## Performance

| Tipo | Refresh | Cache | P95 |
|------|---------|-------|-----|
| Operacional | 30s | Redis | < 200ms |
| Gerencial | 1h | Redis + BI | < 500ms |
| Estratégico | 24h | BI/Lakehouse | < 2s |
| Customizado | Configurável | Sob demanda | < 1s |

---

## Segurança

```text
Widget sem permissão para o perfil = oculto.
Dados filtrados por tenant/unidade/local.
Export apenas se permissão EXPLICITAMENTE concedida.
Drill-down respeita permissão de nível inferior.
Dados sensíveis mascarados conforme role.
Cache respeita tenant (não cacheia dados de tenant A para tenant B).
```

---

## Estados

| Estado | Comportamento |
|--------|---------------|
| Loading | Skeleton para cada widget |
| Error | "Não foi possível carregar este widget" + botão retry |
| Empty | "Nenhum dado disponível para o período selecionado" |
| NoPermission | Widget invisível (não mostra espaço vazio) |

---

## Integrações

| MD | Finalidade |
|----|-----------|
| MD-020 — Portal Core Architecture | Dashboards first-class citizens |
| MD-042A — Portal Experience | Dashboard contextual |
| MD-043 — Dashboard Framework | Framework de dashboards |
| MD-030 — Enterprise Analytics | Analytics, KPIs |
| MD-039 — Analytics Data Intelligence | Intelligence, métricas |
| MD-085 — Data Lakehouse Platform | Fonte de dados analíticos |
| MD-099 — Strategic Command Center | Dashboard estratégico |
| MD-108 — Operational Context Engine | Contexto por dashboard |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-003 — Portal Enterprise Experience | Shell |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Dashboard Engine, Widget Composer, KPI Engine, Filter Bar, Export |
| Backend | APIs de widgets, KPIs, filtros, export |
| Dispatcher | Roteamento para SPs de dashboard e analytics |
| SP | Cálculo de KPIs, regras de negócio de dashboard |
| Event Store | Registrar visualização de dashboard, export, drill-down |

---

## Métricas

```text
Dashboards ativos
Widgets por dashboard
Tempo de carregamento P95
Taxa de erro por widget
Uso de drill-down
Uso de export
Filtros mais usados
Dashboards mais acessados por perfil
Satisfação com dashboards (CSAT)
Skeleton time (tempo até primeiro pixel)
```

---

## Lei

```text
Dashboard é contextual.
Dashboard é permissivo.
Dashboard é dinâmico.
Dashboard é a cara do usuário.
```

---

## Próximo

```text
FRONT-005 completo
  ↓
FRONT-006 — Social Experience
```
