# FRONT-028 — Enterprise Analytics Experience

## Status

Documento Canônico de Frontend.
Define a experiência analítica única da plataforma.

---

## Objetivo

Unificar todas as visões analíticas em experiência consistente e abrangente.

---

## Princípio Fundamental

```text
Analytics não é disperso.
Analytics é único.
Analytics é contextual.
Analytics é ação.
Analytics é previsão.
```

---

## Componentes

### KPITile

```text
Valor principal em destaque
Variação percentual/indicador
Meta comparativa
Trend de linha
Cor por status (verde/warning/vermelho)
Tooltip com detalhes
```

### ChartContainer

```text
Suporte a múltiplos tipos de gráfico
Line, bar, pie, area, funnel, heatmap
Interatividade: tooltip, zoom, pan
Legendas clicáveis
Export como imagem
Drill-down suportado
```

### MapVisualization

```text
Mapa interativo
Zoom e pan
Pontos clicáveis
Clusters automáticos
Heatmap de densidade
Geofence suportado
```

### HeatmapView

```text
Calor por horário
Calor por região
Intensidade configurável
Legenda de cores
Aggregate por período
```

### ForecastPanel

```text
Previsão de tendências
Intervalo de confiança
Sazonalidade detectada
Alertas de anomalia
Precisão do modelo
```

---

## Visões

### Operacional

```text
Foco: execução real-time
Refresh: 30 segundos a 5 minutos
Métricas: throughput, latência, erro
Usuários: operadores, analistas
```

### Gerencial

```text
Foco: performance por área
Refresh: 1 hora a 1 dia
Métricas: KPIs por unidade, ranking
Usuários: gestores, coordenadores
```

### Executiva

```text
Foco: visão de conjunto
Refresh: 1 dia a 1 semana
Métricas: margem, crescimento, market share
Usuários: diretoria, C-level
```

### Estratégica

```text
Foco: tendências e previsões
Refresh: semanal a mensal
Métricas: forecast, benchmark, cenários
Usuários: executivos, board
```

---

## Regras

### Obrigatório

```text
KPI tem meta definida
Gráfico tem tooltip explicativo
Mapa tem legenda
Heatmap tem data/hora
Forecast tem intervalo de confiança
Filtro de contexto é aplicado automaticamente
```

### Proibido

```text
Métrica sem meta
Gráfico sem labels
Mapa sem escala
Heatmap sem interatividade
Forecast sem explicabilidade
Dados brutos sem agregação
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-030 — Enterprise Analytics | Analytics canônico |
| MD-039 — Analytics Data Intelligence | Intelligence |
| MD-085 — Data Lakehouse Platform | Fonte de dados |
| MD-020 — Portal Core Architecture | Portal analytics |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-005 — Dashboard Framework | Dashboards |
| FRONT-012 — Widget Framework | Widgets analytics |
| FRONT-029 — Executive Cockpit | Analytics executivo |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | KPIs, charts, mapas, heatmaps, forecast |
| Backend | APIs de analytics, agregações, KPIs |
| Dispatcher | Roteamento para SPs analíticos |
| SP | Cálculo de KPIs, agregações, regras |
| Event Store | Registrar visualização, drill-down, export |
| IA | Previsões, anomalias, insights |

---

## Métricas

```text
Dashboards criados
Widgets analytics ativos
Taxa de drill-down
Exports de analytics
Previsões geradas
Anomalias detectadas
Satisfação com analytics (CSAT)
Adoção por perfil analítico
```

---

## Lei

```text
Analytics é único.
Analytics é contextual.
Analytics é ação.
Analytics é previsão.
```

---

## Próximo

```text
FRONT-028 completo
  ↓
FRONT-029 — Executive Cockpit
```