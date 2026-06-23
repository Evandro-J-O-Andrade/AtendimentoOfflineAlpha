# FRONT-015 — Command Center UX

## Status

Documento Canônico de Frontend.
Define a experiência do Strategic Command Center (Centro de Comando Estratégico).

---

## Objetivo

Fornecer visão 360, decisão em tempo real e governança executiva em uma só tela.

---

## Princípio Fundamental

```text
Dado sem contexto é ruído.
Contexto sem ação é perda de tempo.
Command Center junta os dois.

A informação correta,
no momento certo,
para a pessoa certa,
em um só lugar.
```

---

## MDs Relacionados

| MD | Finalidade |
|----|-----------|
| MD-099 — Strategic Command Center | Documento canônico do Command Center |
| MD-030 — Enterprise Analytics | Analytics |
| MD-039 — Analytics Data Intelligence | Intelligence |
| MD-078 — Revenue Operations | RevOps, MRR, ARR |
| MD-098 — Enterprise Risk Management | Riscos |
| MD-097 — Compliance Automation | Compliance |
| MD-065 — Observability Platform | Observabilidade |
| MD-066 — SRE Platform | SRE, infra |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-005 — Dashboard Framework | Framework de dashboards |
| FRONT-012 — Widget Framework | Widgets |

---

## Público-Alvo

| Perfil | Acesso | Foco |
|--------|--------|------|
| C-Level (CEO, COO, CFO) | Todos os dashboards | Estratégico, financeiro, risco |
| Diretor | Dashboards gerenciais + operacionais | Por área (RH, Financeiro, Operações) |
| Gerente | Dashboards operacionais + gerenciais | Por equipe/unidade |
| Compliance Officer | Dashboards de compliance + risco | Regulatórios, auditoria, incidentes |
| SRE / DevOps | Dashboards de infraestrutura | Disponibilidade, performance, custo |

---

## Layout Canônico

### Header

```text
Logo + Nome do Tenant (white label)
Seletor de escopo:
  - Todos os tenants (admin)
  - Tenant atual
  - Unidade atual
  - Local atual
Período global (aplicado a todos os widgets)
Data: "Última atualização: {timestamp}"
Ações: Exportar relatório, Compartilhar, Configurar alertas
```

### Sidebar de Navegação

```text
Dashboard Executivo
  ├── Visão Geral
  ├── Receita
  ├── Clientes
  └── Riscos
Operações
  ├── Saúde / HIS
  ├── Farmácia
  ├── Faturamento
  ├── PDV
  └── Logística
TI & Infra
  ├── Aplicações
  ├── APIs
  ├── Incidentes
  └── Custos
Compliance & Risco
  ├── Riscos Abertos
  ├── Incidentes
  ├── Auditorias
  └── Vulnerabilidades
Pessoas
  ├── RH
  ├── Treinamentos
  └── Turnover
Configurações
  ├── Meus Dashboards
  ├── Alertas
  └── Preferências
```

### Workspace (Área Principal)

```text
Grid de widgets organizado por:
  - Linha: categoria de indicador
  - Coluna: proporção (1:1, 2:1, 1:2, full)
Layout responsivo:
  - Desktop: até 4 colunas
  - Tablet: até 2 colunas
  - Mobile: 1 coluna
Sticky header quando scroll
Refresh manual + indicador de última atualização
```

### Footer

```text
Status: "Todos os sistemas operacionais"
Última atualização: timestamp
Versão da plataforma
Links: Documentação, Suporte, Status Page
```

---

## Dashboards Canônicos

### 1. Visão Geral (Executive Overview)

```text
Indicadores de Negócio:
  - Receita total (hoje/semana/mês) — KPI Card
  - MRR / ARR — KPI Card com variação %
  - Churn rate (mês) — KPI Card com gauge
  - New MRR (novos contratos) — KPI Card
  - Net Revenue Retention — KPI Card

Indicadores de Plataforma:
  - Tenants ativos — KPI Card
  - Usuários ativos (DAU/MAU) — Chart Line (últimos 30 dias)
  - Apps mais utilizadas — RankingList (top 10)
  - Taxa de adoção por app — Chart Bar
  - Incidentes abertos — AlertWidget (crítico se > 0)

Indicadores de Saúde:
  - Uptime da plataforma — Gauge (99.9% alvo)
  - Tickets abertos (SAC) — KPI Card
  - SLA médio — Chart Line
  - Backups executados hoje — CheckCircle
```

### 2. Receita (Revenue Operations)

```text
MRR por plano:
  - Free, Pro, Business, Enterprise
  - Chart Bar (stacked por mês)
  - Drill-down: lista de tenants por plano

ARR e Growth:
  - ARR total — KPI Card
  - MRR Growth Rate — Chart Line
  - Expansion MRR vs Churn MRR — Chart Bar

Pipeline:
  - Oportunidades abertas — KPI Card
  - Valor do pipeline — KPI Card
  - Taxa de conversão — Chart Funnel
  - Forecast — Chart Line (real vs. projetado)

Financeiro:
  - Contas a receber — KPI Card
  - Inadimplência — Chart Line
  - Repasses pendentes — DataTable
```

### 3. Clientes (Customer Success)

```text
Tenants:
  - Total ativos — KPI Card
  - Novos (últimos 30 dias) — Chart Bar
  - Por plano — Chart Pie
  - Por indústria — Chart Bar

Churn:
  - Churn rate mensal — Chart Line
  - Churn por plano — Chart Table
  - Motivos de churn — Chart Bar

Satisfação:
  - NPS médio — Gauge
  - CSAT médio — KPI Card
  - Reclamações abertas — KPI Card

Uso:
  - DAU / WAU / MAU — Chart Line
  - Apps mais usadas — RankingList
  - Tokens IA consumidos — Chart Area
```

### 4. Riscos (Risk Management)

```text
Riscos Abertos:
  - Total — KPI Card
  - Por severidade (P1-P4) — Chart Bar
  - Por categoria — Chart Pie
  - Em atraso — AlertWidget (crítico)

Incidentes:
  - Abertos — KPI Card
  - Por severidade
  - MTTR médio — Chart Line
  - Top sistemas afetados — RankingList

Compliance:
  - Regulatórios ativos — KPI Card
  - Scan de vulnerabilidades — DataTable
  - Políticas implementadas vs. pendentes — Chart Bar

Segurança:
  - Tentativas de login bloqueadas — Chart Line
  - Acessos suspeitos — AlertWidget
  - Tokens revogados — KPI Card
```

### 5. Saúde da Plataforma (Observability)

```text
Uptime:
  - Disponibilidade global — Gauge (99.9%)
  - Últimos incidentes — Timeline
  - Status por serviço — DataTable (verde/amarelo/vermelho)

Performance:
  - Latência P95 por API — Chart Line
  - Taxa de erro por API — Chart Bar
  - Throughput (req/s) — Chart Area

Custos:
  - Custo de infra dia/mês — KPI Card + Chart Line
  - Custo por tenant — RankingList
  - Projeção de custo (IA) — Chart Line com forecast
```

### 6. Pessoas (RH)

```text
Colaboradores:
  - Total — KPI Card
  - Por unidade — Chart Bar
  - Turnover mensal — Chart Line

Treinamentos:
  - Cursos ativos — KPI Card
  - Taxa de conclusão — Gauge
  - Certificados emitidos — Chart Bar (últimos 6 meses)

Comunicação:
  - Posts no Feed — Chart Line
  - Eventos criados — KPI Card
  - Engagement médio — Gauge
```

---

## Regras

### Acesso

```text
C-Level: acesso total
Diretor: dashboards de suas áreas + visão geral
Gerente: dashboards operacionais + gerenciais da sua área
Compliance Officer: compliance + risco + auditoria
SRE: infra + performance + custos
```

### Atualização

```text
Estratégico (C-Level): 24h padrão, manual disponível
Gerencial (Diretor/Gerente): 1h padrão, manual disponível
Operacional (Gerente): 30min padrão, manual disponível
Infra (SRE): tempo real (1min), manual = "Atualizar agora"
```

### Interatividade

```text
Drill-down:
  - Diretor pode ver até nível unidade
  - Gerente pode ver até nível local
  - C-Level pode ver agregado global

Export:
  - PDF branded (tenant)
  - Excel com múltiplas abas
  - CSV por widget
  - Agendamento de export automático (diário/semanal)

Compartilhamento:
  - Link público (opcional, com expiração)
  - Email direto
  - Embed em portal (iframe seguro)
```

### Alertas Inteligentes

```text
Alertas sugeridos por IA baseados em:
  - Anomalias detectadas
  - Tendências de risco
  - Quedas em métricas-chave
  - Aproximação de limites (ex: orçamento 90%)
Exemplo:
  "⚠️ Faturamento do dia está 15% abaixo da média.
   Causa provável: queda em Farmácia (-22%).
   Quer investigar?"
Ações: [Abrir dashboard] [Silenciar por 24h] [Criar tarefa]
```

---

## Estados

| Estado | Comportamento |
|--------|---------------|
| Loading | Skeleton para cada widget, com shimmer |
| Error | "Não foi possível carregar [widget]" + botão retry individual |
| Partial | Widgets com erro mostram placeholder, restante carrega normalmente |
| Empty | "Nenhum dado disponível para o período selecionado" |
| Stale | Indicador "Dados desatualizados" + botão refresh |

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-099 — Strategic Command Center | Documento canônico |
| MD-030 / MD-039 — Analytics | Dados analíticos |
| MD-078 — Revenue Operations | Receita |
| MD-098 — Enterprise Risk Management | Riscos |
| MD-097 — Compliance Automation | Compliance |
| MD-065 — Observability | Infra |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-005 — Dashboard Framework | Framework de dashboards |
| FRONT-012 — Widget Framework | Widgets |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Layout, widgets, drill-down, export, alertas |
| Backend | APIs de analytics, KPIs, export, agendamento |
| Dispatcher | Roteamento para SPs e APIs de analytics |
| SP | Cálculo de KPIs executivos, regras de negócio |
| Event Store | Registrar visualização, drill-down, export, compartilhamento |
| IA | Alertas inteligentes, anomaly detection, forecast |

---

## Métricas

```text
Dashboards acessados por dia
Tempo de carregamento P95
Drill-downs por sessão
Exports por dia
Alertas gerados vs. acionados
Compartilhamentos
Satisfação da liderança (CSAT)
Tempo de decisão reduzido (pesquisa)
```

---

## Lei

```text
Dado sem contexto é ruído.
Contexto sem ação é perda de tempo.
Command Center junta os dois.

Informação correta.
No momento certo.
Para a pessoa certa.
Em um só lugar.
```

---

## Fim da Fase 2

```text
FRONT-001 até FRONT-015
DOCUMENTADOS

Próxima fase:
  FASE 3 — MAP-001 até MAP-010
```

---

Documento Canônico de Frontend — FRONT-015

**Fim da camada de experiência do usuário.**
