# MD-085 — Data Lakehouse Platform

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Centralizar inteligência de dados para Analytics, IA e Governança.

---

## Princípio Fundamental

```text
Dado bruto não perde valor.

Dado curado ganha utilidade.

Dado unificado gera decisão.
```

---

## Fontes

```text
Portal
CRM
SAC
PDV
Financeiro
Analytics
Marketplace
Social
IA
IoT (futuro)
Mobile
Event Store
Workflow Fabric
N8N
```

---

## Estrutura

### Raw

```text
Dados ingeridos sem transformação
Formato: Parquet/JSON
Retenção: ilimitada
Imutável
Particionado por data/tenant
```

### Curated

```text
Limpeza
Deduplicação
Enriquecimento
Padronização
Mascaramento de dados sensíveis
Validação de schema
```

### Business

```text
Modelos dimensionais
Marts por domínio (Vendas, Financeiro, RH)
Agregações pré-calculadas
Snowflake schema estendido
Multi-tenant por design
```

### AI

```text
Datasets de treino
Features engineering
Experimentação
Modelos registrados
Linhas de base
Métricas de drift
```

---

## Camadas

```
Ingestion
  ↓
Raw Zone (Lake)
  ↓
Curated Zone (Silver)
  ↓
Business Zone (Gold / Marts)
  ↓
AI Zone (Feature Store)
  ↓
Consumption
  ├── Analytics
  ├── BI
  ├── IA
  ├── Relatórios
  └── APIs externas
```

---

## Integrações

```text
MD-051 Data-Lake-Architecture
MD-039 Analytics-Data-Intelligence
MD-033 Analytics-Governance
MD-052 AI-Data-Fabric
MD-053 Enterprise-Search
MD-087 Enterprise-Search
MD-071 Customer-360
MD-025 Event-Store
MD-055 Digital-Twin-Organization
MD-038 Integration-Hub
```

---

## Regras

1. Raw nunca é sobrescrito.
2. Curated pode ser reprocessado.
3. Business é read-only para consumo.
4. AI respeita privacy by design.
5. Acesso é sempre por tenant e por papel.
6. Qualidade (DQ) é monitorada continuamente.
7. Custo de armazenamento é otimizado por tier (hot/warm/cold).
8. Todos os acessos são auditados.

---

## Lei

```text
Dado sem governança é risco.

Dado com plataforma é ativo.

Lakehouse não armazena tudo.

Lakehouse organiza o que importa.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Pipeline de ingestão
Governança de metadados
Qualidade de dados
Particionamento e tiering
Segurança e mascaramento
Backup e recuperação
Catálogo de dados
```

Times são responsáveis por:

```text
Definir regras de negócio
Validar qualidade dos dados
Criar marts de consumo
Documentar domínios
Reportar anomalias
```

---

## Métricas

```text
Volume ingerido (TB/dia)
Volume curado (% do raw)
Qualidade de dados (% records valid)
Consultas por dia
Latência de dashboard
Custo de armazenamento por TB
Cobertura do catálogo
Drift de dataset IA
Tempo de reprocessamento
Disponibilidade da plataforma
```
