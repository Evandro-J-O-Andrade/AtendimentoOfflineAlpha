# MD-066 — SRE Platform

## Status

Documento Canônico da Plataforma SRE da Plataforma Enterprise.

---

## Objetivo

Confiabilidade operacional da plataforma.

SRE como cultura, não apenas ferramenta.

---

## Princípio Fundamental

```text
Toda falha deve ser mensurável.

Toda medição deve gerar ação.

Toda ação deve ser documentada.
```

---

## SRE Architecture

```text
SLI/SLO/SLA Definition
    ↓
Monitoring (MD-065)
    ↓
Alerting
    ↓
Incident Management
    ↓
Post-Mortem
    ↓
Improvement
```

---

## SLI/SLO/SLA

### SLI (Service Level Indicator)

```text
Disponibilidade
Latência
Throughput
Erro rate
Tempo de boot
Tempo de deploy
```

### SLO (Service Level Objective)

```text
99.9% disponibilidade mensal
p99 latência < 500ms
Error budget < 0.1%
Mean time to detect < 5min
Mean time to recover < 30min
```

### SLA (Service Level Agreement)

```text
99.5% uptime garantido
Suporte 24x7 para Enterprise
P0 resposta < 15min
Créditos por breach
```

---

## Error Budget

```text
Error Budget = 100% - SLO

Exemplo: 99.9% SLO → 0.1% error budget

Uso do budget:
  - Feature releases consomem budget
  - Bugs consomem budget
  - Mudança de risco consome budget

Quando budget zerado:
  - Feature freeze
  - Foco em reliability
  - Mudanças apenas critical
```

---

## Incident Management

### Severity Levels

```text
SEV1 (P0): Platform down, data loss, security breach
SEV2 (P1): Major feature down, SLA breach imminent
SEV3 (P2): Minor impact, workaround exists
SEV4 (P3): No user impact, informational
```

### Response Process

```text
1. Alert triggered
2. On-call engineer acknowledges
3. Initial assessment (impact scope)
4. War room opened (if SEV1/SEV2)
5. Communication (status page + stakeholders)
6. Mitigation (rollback, scale, disable)
7. Resolution (fix deployed, verified)
8. Post-mortem scheduled
```

### Runbook

```text
Todo incident tem runbook
Runbook incluí:
  - O que monitorar
  - Comandos de diagnóstico
  - Passos de mitigação
  - Quem contactar
  - Quando escalar
  - Como comunicar
```

---

## Post-Mortem

### Obrigatório para

```text
SEV1 incidents
SEV2 incidents
Data loss events
Security breaches
SLA breaches
Customer-impacting > 1h
```

### Post-Mortem Template

```text
Timeline do incident
Root cause
Impact assessment
What went well
What went wrong
What we learned
Action items (com owner e prazo)
Follow-up date
```

### Post-Mortem Rules

```text
Blameless culture
Focus on process, not people
Publish internally
Share with customer quando relevante
Action items tracked
```

---

## Capacity Planning

```text
Current capacity
Growth projections
Headroom target (20-30%)
Scaling triggers
Bottleneck analysis
Resource requests
```

---

## Change Management

```text
All changes tracked
Risk assessment per change
Rollback plan required
Canary deployment for risky changes
Change freeze periods (black friday, etc.)
```

---

## Integration with Other MDs

- **MD-065 (Observability)**: observabilidade é a base do SRE.
- **MD-010 (Security)**: incidentes de segurança.
- **MD-016 (Auditoria)**: auditoria de incidentes.
- **MD-067 (Disaster Recovery)**: DR como ultimato do SRE.
- **MD-070 (Platform Operations)**: operations unificado.

---

## Próximo MD recomendado

```text
MD-067 — Disaster Recovery
```

Recuperação de desastre.