# MD-131 — Management Panels Architecture

## Status
Documento Canônico da Plataforma. Painéis gerenciais.

## Classificação
```text
Tipo: Capability Architecture
Camada: Shared Capabilities
Prioridade: Média
Obrigatoriedade: All Domains
```

---

## Objetivo
Painéis gerenciais são visão operacional consolidada. Focados em decisão, não em operação.

---

## Lei Canônica MD-131-001
```text
Painel gerencial NÃO é painel operacional.
Foco em trends, não em ação.
KPIs são agregados.
```

---

## Panel Types

```text
Daily Operations
├── Volume de atendimentos
├── Taxa de conversão
├── Tempo médio
└── Metas do dia

Weekly Trends
├── Evolução semanal
├── Comparativo histórico
├── Sazonalidade
└── Previsões

Monthly Report
├── KPIs mensais
├── Análise de causa
├── Benchmarking
└── Investigação
```

---

## Integrações
| MD | Finalidade |
|----|---|
| MD-130 | Clinical Panels Architecture |
| MD-135 | Enterprise Analytics Architecture |
| MD-142 | Unified Enterprise Operating System |