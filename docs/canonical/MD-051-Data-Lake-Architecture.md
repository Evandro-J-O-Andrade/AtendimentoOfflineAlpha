# MD-051 — Data Lake Architecture

## Status

Documento Canônico da Arquitetura de Data Lake da Plataforma Enterprise.

---

## Objetivo

Criar o repositório corporativo unificado de dados brutos e processados da plataforma.

Separar carga operacional de análise.

Fundação para Analytics, IA e Governança.

---

## Princípio Fundamental

```text
Banco operacional executa.

Data Lake analisa.

Nenhum dashboard pesado consulta
o banco operacional diretamente.
```

---

## Data Lake Architecture

```text
Ingestion Layer
Storage Layer
Processing Layer
Catalog Layer
Governance Layer
Consumption Layer
```

---

## Data Sources

Origens canônicas:

```text
Portal Core
CRM
SAC
PDV
Financeiro
Analytics
Social Network
AVA
Marketplace
Operacional
HIS
IoT
Apps futuras
Event Store
Audit Trail
External APIs
```

---

## Data Lake Zones

### Bronze Zone

```text
Dados brutos
Sem transformação
Sem limpeza
Formato original
Retenção ilimitada
Imutável
```

Tipos:

```text
JSON raw
CSV exports
API responses
Log files
Binary files
Stream data
Batch data
```

### Silver Zone

```text
Dados limpos
Normalizados
Enriquecidos
Validad0s
Prontos para consumo
Retenção configurável
```

Processos:

```text
Schema enforcement
Data validation
Deduplication
Format standardization
Metadata enrichment
PII masking
PII encryption
```

### Gold Zone

```text
Dados agregados
Modelados
Otimizados para BI
Otimizados para IA
Data Warehouse structures
Aggregations
Materialized views
```

### Platinum Zone

```text
Dados enriquecidos com IA
Insights pré-computados
Predictions
Anomalies
Recommendations
Ready-to-serve para apps
```

---

## Storage

### Object Storage

```text
MinIO (self-hosted)
AWS S3
Azure Blob
GCP Cloud Storage
```

### Organization

```text
tenant/{id_tenant}/
  raw/
  silver/
  gold/
  platinum/
  archival/
```

### Retention

```text
Bronze: ilimitado (com archive policy)
Silver: configurável por domínio
Gold: conforme necessidade negocial
Platinum: rolling window (30-90 dias)
Archive: cold storage para compliance
```

---

## Ingestion

### Batch Ingestion

```text
Daily full sync
Daily incremental sync
Weekly aggregations
Monthly partitions
Ad-hoc imports
```

### Streaming Ingestion

```text
Real-time events from Event Store
CDC (Change Data Capture)
API webhooks
IoT sensor data
Log streams
```

### Ingestion Tools

```text
N8N workflows (MD-038)
Apache Spark
Apache Flink
Custom ETL jobs
Airflow scheduling
```

---

## Processing

### ETL Pipelines

```text
Extract from sources
Transform (clean, normalize, enrich)
Load to zones
Quality checks
Monitoring
Alerting
```

### ELT Pipelines

```text
Extract raw
Load to Bronze
Transform in-place
Leverage Data Warehouse compute
```

### Processing Patterns

```text
Batch: Spark, SQL
Streaming: Flink, Kafka Streams
Micro-batch: Airflow + Spark
Serverless: cloud functions
```

---

## Data Catalog

### Metadata

```text
Schema definitions
Data lineage
Data ownership
Data quality metrics
Sensitivity classification
Retention policies
Access controls
```

### Search & Discovery

```text
Full-text search
Faceted search
Tag-based search
Business glossary
Data dictionary
```

---

## Governance

### Data Governance

```text
Data ownership
Data stewardship
Access policies
Quality rules
Retention policies
Deletion policies
PII handling
Compliance enforcement
```

### Data Quality

```text
Completeness checks
Uniqueness checks
Validity checks
Timeliness checks
Consistency checks
Accuracy checks
Quality scores
Anomaly detection
```

---

## Consumption

### BI & Analytics

```text
Dashboards (MD-030)
Executive Center
Ad-hoc queries
Self-service BI
```

### AI & ML

```text
Training datasets
Feature stores
Model inputs
Predictions
```

### Apps

```text
Portal apps
CRM analytics
SAC analytics
Operational analytics
```

### APIs

```text
Internal APIs
External APIs
Partner APIs
Data sharing
```

---

## Integration with Other MDs

- **MD-002 (Auth)**: acesso controlado ao Data Lake.
- **MD-003 (Operational Context)**: contexto para filtros de dados.
- **MD-004 (Dispatcher)**: ações sobre dados.
- **MD-005 (Event Store)**: fonte de eventos para ingestion.
- **MD-010 (Security)**: segurança de dados.
- **MD-014 / MD-019 (App Registry)**: apps que consomem dados.
- **MD-016 (Auditoria)**: auditoria de acesso a dados.
- **MD-017 (MultiTenant)**: isolamento por tenant no storage.
- **MD-020 (Portal Core)**: portal consome dados.
- **MD-025 (Event Store Core)**: eventos como fonte.
- **MD-030 (Enterprise Analytics)**: consome Data Lake.
- **MD-033 (Analytics Governance)**: governança de dados.
- **MD-034 (IAM)**: permissões de acesso a dados.
- **MD-035 (Security Trust Architecture)**: security para dados.
- **MD-038 (Integration Hub)**: ingestão de dados externos.
- **MD-039 (Analytics Data Intelligence)**: intelligence sobre dados.

---

## Próximo MD recomendado

```text
MD-052 — AI Data Fabric
```

Malha de dados para IA.

---

## Regras Canônicas

1. Data Lake separa operacional de analítico.
2. Bronze é raw, imutável, completo.
3. Silver é limpo, normalizado, enriquecido.
4. Gold é modelado, otimizado para BI.
5. Platinum é IA-ready.
6. Todo dado tem origem rastreável.
7. Todo dado tem qualidade medida.
8. Todo dado tem dono.
9. Data Lake respeita tenant isolation.
10. Data Lake respeita Security e LGPD.
11. PII é mascarado em Silver+.
12. Sensitive data é criptografado.
13. Retention é automática.
14. Deleção é auditada.
15. Data Lake alimenta Analytics, não o operacional.
16. Event Store é fonte primária.
17. Ingestion é event-driven.
18. Catalog é obrigatório.
19. Quality é monitored.
20. Data Lake é patrimônio da plataforma.

---

## Proibições

São proibidos:

```text
Dashboard consultando banco operacional
Dados sensíveis em Bronze sem proteção
Ingestão sem catalogação
Deleção sem auditoria
Cross-tenant data access
Schema on read sem enforcement
PII em zonas não protegidas
Overwriting de dados brutos
Access sem IAM
Storage sem criptografia
```
