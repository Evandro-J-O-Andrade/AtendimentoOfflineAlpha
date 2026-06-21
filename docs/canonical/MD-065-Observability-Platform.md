# MD-065 — Observability Platform

## Status

Documento Canônico da Plataforma de Observabilidade da Plataforma Enterprise.

---

## Objetivo

Observabilidade total da plataforma.

Logs, métricas, traces, alertas.

---

## Princípio Fundamental

```text
Tudo é observável.

Nada é invisível.

Toda falha é detectável.
```

---

## Observability Architecture

```text
Sources (apps, runtime, infra)
    ↓
Collectors (logs, metrics, traces)
    ↓
Processors (filter, transform, enrich)
    ↓
Storage (hot, warm, cold)
    ↓
Dashboards & Alerts
    ↓
Incident Response
```

---

## Three Pillars

### Logs

```text
Application logs
Access logs
Audit logs (Event Store)
Security logs
Integration logs
Error logs
Performance logs
AI execution logs
N8N workflow logs
```

### Metrics

```text
System metrics: CPU, RAM, Disk, Network
Application metrics: latency, throughput, errors
Business metrics: transactions, users, revenue
AI metrics: tokens, latency, cost, accuracy
SLO metrics: availability, performance, capacity
```

### Traces

```text
Request trace: user → portal → dispatcher → SP → DB
Event trace: event created → queued → processed
Sync trace: local → cloud → confirmed
AI trace: prompt → model → response → action
Integration trace: webhook received → processed → response
```

---

## Stacks

### Logs

```text
ELK Stack (Elasticsearch, Logstash, Kibana)
Cloud-native: CloudWatch, Azure Monitor
Structured logging (JSON)
Log levels: DEBUG, INFO, WARN, ERROR, FATAL
Retention: 30d hot, 90d warm, 1y cold
```

### Metrics

```text
Prometheus + Grafana
Cloud-native alternatives
Custom metrics via SDK
SLO tracking
Alert thresholds
```

### Traces

```text
OpenTelemetry (standard)
Jaeger (open source)
Distributed tracing
Span correlation
Service map
```

---

## Dashboards

### Infrastructure Dashboard

```text
Cluster health
Node status
Resource utilization
Network traffic
Storage usage
Container health
```

### Application Dashboard

```text
Request rate
Error rate
Latency percentiles (p50, p95, p99)
Active sessions
Queue depth
SP execution time
```

### Business Dashboard

```text
Active tenants
Active users
Transactions per minute
Revenue indicators
NPS trend
Churn indicators
```

### Security Dashboard

```text
Failed logins
Suspicious IPs
Token revocations
Permission denials
Security alerts
Compliance status
```

### AI Dashboard

```text
Tokens consumed
Model latency
Error rate by model
Cost per tenant
Cache hit rate
Hallucination rate
```

---

## Alerting

### Severity Levels

```text
P0 (Critical): system down, data loss, security breach
P1 (High): major feature degraded, SLA at risk
P2 (Medium): minor issues, degraded performance
P3 (Low): informational, trending issues
```

### Alert Channels

```text
PagerDuty / Opsgenie (P0, P1)
Slack / Teams (P1, P2)
Email (P2, P3)
Dashboard only (P3)
```

### Alert Rules

```text
CPU > 90% for 5min
Memory > 85% for 5min
Error rate > 1% for 2min
Latency p99 > 2s for 5min
Disk > 80% for 10min
Queue depth > 10000
Failed logins > 100/min
```

---

## SLO/SLI/SLA

### SLI (Service Level Indicator)

```text
Availability: uptime / total time
Latency: % requests under threshold
Error Rate: % requests that fail
Throughput: requests per second
```

### SLO (Service Level Objective)

```text
Availability: 99.9%
Latency p99: < 500ms
Error Rate: < 0.1%
Data Freshness: < 5min for critical
```

### SLA (Service Level Agreement)

```text
Uptime: 99.5% contracted
Support response: P0 < 15min
Resolution: P0 < 4h
Penalty: credit for breach
```

---

## Correlation

```text
Trace ID connects logs, metrics, traces
Correlation across:
  - Portal → Dispatcher → SP → DB
  - Frontend → Backend → Integration
  - Event → Queue → Processing → Analytics
  - User action → Event → Sync → Cloud
```

---

## Integration with Other MDs

- **MD-003 (Operational Context)**: contexto para alertas.
- **MD-004 (Dispatcher)**: traces de dispatcher.
- **MD-005 (Event Store)**: eventos como métricas.
- **MD-010 (Security)**: security events.
- **MD-016 (Auditoria)**: audit trails observáveis.
- **MD-061 (Edge Runtime)**: runtime observável.
- **MD-066 (SRE Platform)**: SRE usa observabilidade.
- **MD-067 (Disaster Recovery)**: DR usa observabilidade.
- **MD-070 (Platform Operations)**: operations usa observabilidade.

---

## Próximo MD recomendado

```text
MD-066 — SRE Platform
```

Confiabilidade operacional.

---

## Regras Canônicas

1. Todo componente é observável.
2. Logs são estruturados (JSON).
3. Logs não contêm secrets.
4. Métricas são padronizadas.
5. Traces são correlacionados por Trace ID.
6. Alertas são acionáveis.
7. Alertas tem runbook.
8. Dashboards são organizados por stakeholder.
9. SLO são públicos internamente.
10. On-call é definido por serviço.
11. Incident response é documentado.
12. Post-mortem é obrigatório para P0.
13. Observability é prioridade, não afterthought.
14. Sampling para traces (custo).
15. Retention é configurável por tipo.
16. PII é mascarado em logs.
17. Security events são separados.
18. Cost tracking inclui observabilidade.
19. Observabilidade alimenta Analytics.
20. Observabilidade é transparência.

---

## Proibições

São proibidos:

```text
Log sem estrutura JSON
Log contendo senha, token, secret
Metric sem label padronizado
Trace sem Trace ID
Alerta sem runbook
Dashboard sem owner
Observabilidade apenas para produção
PII em logs sem mascaramento
Retention infinita
Alerta que acorda todo mundo (alerta fatigue)
Sem correlação entre pilares
Sem SLO definidos
```