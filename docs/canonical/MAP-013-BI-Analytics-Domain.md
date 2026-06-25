# MAP-013 — BI & Analytics Domain

## Status
CANÔNICO
DOMÍNIO INTELIGÊNCIA
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de inteligência de dados e KPIs.

Controla: Indicadores, dashboards, relatórios, gargalos, performance.

---

# 2. Lei Fundamental

```text
Dado bruto é evento. Informação é derivada. Decisão é apoiada.
```

---

# 3. Fluxo Macro

```text
Eventos → Agregação → Indicadores → Dashboards → Decisao
```

---

# 4. Entidades Centrais

```text
Indicador
Dashboard
Relatorio
Gargalo
Performance
Meta
Analise
```

---

# 5. Eventos Gerados

```text
METRIC_CALCULATED
DASHBOARD_VIEWED
REPORT_GENERATED
BOTTLENECK_DETECTED
TARGET_MISSED
ALERT_TRIGGERED
```

---

# 6. Regras Macro

- Dashboard é derivado de eventos
- Indicador tem fonte canônica
- Performance é comparativa
- Alerta é automático

---

# 7. Integrações

```text
MD-051 Data Lake
MD-136 Event Driven (Fonte)
MD-135 Enterprise Analytics (Consumo)
MAP-011 Admin (Contexto)
MAP-010 Billing (Indicadores financeiros)
```