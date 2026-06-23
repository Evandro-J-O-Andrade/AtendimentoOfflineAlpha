# FRONT-029 — Executive Cockpit

## Status

Documento Canônico de Frontend.
Define o painel único para diretoria executiva.

---

## Objetivo

Consolidar todas as métricas críticas da organização em painel executivo único.

---

## Princípio Fundamental

```text
Executivo não tem tempo para dispersão.
Executivo precisa de decisão rápida.
Executivo precisa de contexto.
Executivo precisa de ação.
Cockpit é consolidação.
```

---

## Componentes

### RevenuePanel

```text
MRR/ARR atual
Variação do mês
Previsão (forecast)
Burn rate
Margem
Pipeline de vendas
```

### CostPanel

```text
Custo total
Custo por categoria (infra, pessoal, operação)
Orçamento vs. gasto
Projeção de custo futuro
ROI por initiative
Despesas recorrentes vs. variáveis
```

### OperationPanel

```text
Uptime da plataforma
Incidentes abertos
Tickets críticos
SLA médio
Tempo de resposta
Throughput de operações
```

### RHPanel

```text
Total de colaboradores
Turnover mensal
Ausências
Contratações pendentes
Treinamentos concluídos
NPS interno
```

### CustomerPanel

```text
Tenants ativos
Churn rate
NPS médio
Tickets abertos
Satisfação média
Crescimento de clientes
```

### SecurityPanel

```text
Tentativas de ataque bloqueadas
Vulnerabilidades críticas
Compliance status
Tokens revogados
Acessos suspeitos
Certificados vencidos
```

### IApanel

```text
Tokens consumidos
Custo de IA
Agentes ativos
Satisfação com IA
Automações executadas
Insights gerados
```

---

## Layout

### Header

```text
Seletor de período (dia, semana, mês, trimestre, ano)
Comparativo vs. período anterior
Export rápido (PDF, Excel)
Compartilhar link
Status geral (todos verdes)
```

### Grid de Widgets

```text
4 colunas em desktop
2 colunas em tablet
1 coluna em mobile
Ordem fixa por relevância
Atualização automática
```

### Alertas

```text
Alerta crítico no header
Notificação sonora opcional
Lista de alertas prioritários
Ação rápida (1 clique)
Escalar para gerente
```

---

## Regras

### Obrigatório

```text
Todas as métricas têm meta
Alertas são críticos e acionáveis
Dados atualizados a cada hora
Export com branding do tenant
Compartilhamento com expiração
```

### Proibido

```text
Métrica sem meta
Alerta sem ação
Dashboard sem atualização
Export sem proteção
Link sem expiração
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-099 — Strategic Command Center | Command Center |
| MD-030 — Enterprise Analytics | Analytics |
| MD-078 — Revenue Operations | Receita |
| MD-098 — Enterprise Risk Management | Riscos |
| MD-097 — Compliance Automation | Compliance |
| MD-088 — HR Management | RH |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-028 — Enterprise Analytics Experience | Analytics |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Layout, widgets, alertas, export |
| Backend | APIs agregadas, KPIs executivos |
| Dispatcher | Roteamento para SPs executivos |
| SP | Cálculo de KPIs, consolidação |
| Event Store | Registrar acesso, export, compartilhamento |
| IA | Insights executivos, forecast |

---

## Métricas

```text
Acessos ao cockpit por executivo
Tempo médio de visualização
Exports realizados
Alertas acionados
Decisões registradas
Satisfação executiva (CSAT)
Uso por horário
Páginas mais acessadas
```

---

## Lei

```text
Executivos enxergam a organização inteira.
```

---

## Próximo

```text
FRONT-029 completo
  ↓
FRONT-030 — Enterprise Home Personalization
```