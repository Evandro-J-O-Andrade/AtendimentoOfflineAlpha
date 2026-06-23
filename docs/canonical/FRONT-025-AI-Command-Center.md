# FRONT-025 — AI Command Center

## Status

Documento Canônico de Frontend.
Define a governança de IA na plataforma.

---

## Objetivo

Governar toda IA da plataforma exibindo tokens, custos, agentes, prompts, execuções e treinamentos.

---

## Princípio Fundamental

```text
IA não é negócio obscuro.
IA é governança.
IA é transparência.
IA é otimização.
IA é controle.
```

---

## Componentes

### TokenTracker

```text
Consumo em tempo real
Histórico por tenant
Previsão de gasto
Alertas de limite (80%, 90%, 100%)
Custo por modelo
Custo por app
```

### CostDashboard

```text
Custo total por período
Custo por provedor
Custo por tenant
Custo por app
Margem de lucro
Budget vs. gasto
Projeção de custo futuro
```

### AgentRegistry

```text
Lista de agentes ativos
Status de cada agente
Versão do agente
Última execução
Custo acumulado
Latência média
Taxa de sucesso
```

### PromptLibrary

```text
Catálogo de prompts canônicos
Prompt customizado por tenant
Performance de prompts
Teste A/B de prompts
Histórico de mudanças
Tags por categoria
```

### ExecutionMonitor

```text
Execuções em tempo real
Status da execução
Tempo de processamento
Tokens usados
Logs de execução
Erro e retry
Resultados
```

### TrainingCenter

```text
Jobs de treinamento ativos
Status do training
Progresso visual
Dataset usado
Métricas de performance
Modelo produção vs. staging
Rollback de modelo
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| MD-104 — AI Platform | Plataforma de IA |
| MD-054 — AI Gateway | Gateway de provedores |
| MD-055 — AI Providers | OpenAI, Gemini, Claude, Locais |
| MD-056 — AI Training | Treinamento SFT/DPO/RFT |
| MD-057 — AI Agents | Agentes de IA |
| MD-058 — AI Prompts | Gerenciamento de prompts |
| MD-052 — Audit Trail Architecture | Auditoria de IA |
| MD-110 — Canonical Laws | Leis supremas |
| FRONT-024 — AI Experience Framework | Uso de IA |

---

## Responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Frontend | Dashboards, monitoramento, alertas, relatórios |
| Backend | APIs de monitoramento, custos, métricas |
| Dispatcher | Roteamento para SPs de IA |
| SP | Cálculo de custos, métricas de performance |
| Event Store | Registrar consumo, execução, custo |

---

## Métricas

```text
Tokens consumidos por dia/mês
Custo total por período
Custo por tenant
Custo por app
Custo por provedor
Jobs de training ativos
Agentes em produção
Prompts mais usados
Latência média por modelo
Taxa de erro por provedor
```

---

## Lei

```text
IA é governança.
IA é transparência.
IA é otimização.
IA é controle.
```

---

## Próximo

```text
FRONT-025 completo
  ↓
FRONT-026 — Marketplace Experience
```