# MD-052 — AI Data Fabric

## Status

Documento Canônico da Malha de Dados para IA da Plataforma Enterprise.

---

## Objetivo

Criar a camada que conecta todos os dados da plataforma aos motores de IA.

Garantir acesso governado, seguro e contextual.

IA sem acesso direto a bancos.

---

## Princípio Fundamental

```text
A IA nunca acessa dados
sem passar pelo IAM.

Dados sensíveis nunca chegam
desmascarados ao modelo.
```

---

## AI Data Fabric Architecture

```text
Data Sources
    ↓
Connector Layer
    ↓
Policy Engine (IAM + Security)
    ↓
Context Resolver
    ↓
Feature Store
    ↓
Prompt/RAG Layer
    ↓
AI Providers
    ↓
Output Guardrails
    ↓
Audit & Feedback Loop
```

---

## AI Connectors

### LLM Providers

```text
OpenAI (GPT-4o, o1, embeddings)
Gemini (Google)
Claude (Anthropic)
DeepSeek
Llama (Meta, self-hosted)
Mistral
Azure OpenAI
Local LLM (Ollama, vLLM, llama.cpp)
```

### Connector Responsibilities

```text
Unified API para todos providers
Load balancing
Failover automático
Cost tracking por tenant
Rate limiting por provider
Token accounting
Timeout handling
Retry with backoff
Circuit breaker
Health monitoring
```

---

## Feature Store

Armazena features para IA:

```text
User features
Tenant features
Context features
Behavioral features
Business features
Temporal features
Derived features
Embeddings
```

### Feature Categories

```text
Identity features: perfil, histórico, preferências
Behavioral features: padrões de uso, engajamento
Business features: tenant setor, porte, história
Context features: unidade, local, perfil, horário
Temporal features: dia, semana, mês, sazonalidade
Composite features: combinações para modelos específicos
```

### Feature Store Model

```json
{
  "feature_uuid": "UUID",
  "tenant_id": 0,
  "entity_type": "USUARIO|CLIENTE|TICKET|DOCUMENTO",
  "entity_id": "UUID",
  "features": {},
  "embeddings": [],
  "version": "string",
  "valid_from": "datetime",
  "valid_to": "datetime",
  "source": "EVENT_STORE|CRM|SAC|ANALYTICS",
  "created_at": "datetime"
}
```

---

## RAG Layer

Retrieval-Augmented Generation:

```text
Query
    ↓
Embedding
    ↓
Vector Search (Data Lake + Feature Store)
    ↓
Context Assembly
    ↓
Prompt Construction
    ↓
IA Provider
    ↓
Response
    ↓
Guardrails
    ↓
Output + Audit
```

### RAG Sources

```text
Wiki corporativa (MD-029)
Documentos da plataforma
Base de conhecimento (GLPI)
Regras de negócio
Políticas corporativas
Histórico de atendimento (SAC)
Conteúdo de cursos (AVA)
Posts e communidades (Social)
FAQ
Manuais técnicos
```

---

## AI Agents

### Enterprise Agents

```text
Agent Assistente Geral: responde perguntas da plataforma
Agent CRM: pipeline, leads, oportunidades
Agent SAC: triagem, classificação, sugestão
Agent Financeiro: análise, projeção, alertas
Agent RH: políticas, benefícios, treinamentos
Agent Jurídico: contratos, compliance, cláusulas
Agent Analytics: insights, anomalias, forecasts
Agent Social: moderação, sugestão de conteúdo
Agent Operacional: rotinas, alertas, diagnósticos
Agent GLPI: triagem, classificação, resolução
```

### Agent Model

```json
{
  "agent_uuid": "UUID",
  "tenant_id": 0,
  "codigo": "AGENTE_SAC",
  "nome": "Agente SAC",
  "dominio": "SAC",
  "tipo": "ASSISTENTE|TRIAGEM|ANALISE|PREDICAO",
  "prompt_system": "string",
  "tools": [],
  "permissions": [],
  "context_sources": ["SAC", "CRM", "ANALYTICS"],
  "guardrails": {},
  "version": "string",
  "status": "ACTIVE|PAUSED|ERROR",
  "owner_id": "UUID",
  "created_at": "datetime"
}
```

---

## Prompt Management

### Prompt Templates

```text
System prompts por domínio
Context-aware prompts
Multilingual prompts
Chain-of-thought prompts
Few-shot examples
Few-shot prompts
Prompt versioning
A/B testing de prompts
```

### Prompt Security

```text
Prompt injection protection
Jailbreak detection
PII extraction prevention
Output sanitization
Content filtering
Harmful content blocking
Brand safety
Hallucination mitigation
```

---

## AI Governance

### Control Tower

```text
Prompt registry
Model registry
Agent registry
Execution ledger
Cost tracking per tenant
Token accounting
Performance monitoring
Drift detection
Bias monitoring
```

### Audit Log

```text
Toda execução é logada
Prompt enviado
Modelo usado
Tokens consumidos
Contexto acessado
Resposta gerada
Ações executadas
Tempo de resposta
Custo
Usuário operador
```

### Cost Governance

```text
Budget por tenant
Budget por agente
Budget por usuário
Budget por período
Alertas de custo
Rate limiting de IA
Model routing por custo
Cache de respostas
```

---

## Model Context Protocol

Contexto para IA:

```text
Who (identidade, perfil, tenant)
What (app, ação, domínio)
Where (unidade, local)
When (horário, data, período)
Why (intenção, contexto de negócio)
History (eventos anteriores, preferências)
Constraints (permissões, políticas, compliance)
```

### Context Assembly

```text
User session
    ↓
Tenant context
    ↓
App context
    ↓
Operational context
    ↓
Relevant history (Event Store)
    ↓
Relevant documents (RAG)
    ↓
Relevant features (Feature Store)
    ↓
Composed context → Prompt
```

---

## Output Guardrails

### Content Guardrails

```text
PII filtering
Secrets redaction
Competitive info protection
Tone enforcement
Language enforcement
Length constraints
Format constraints
```

### Safety Guardrails

```text
Harmful content detection
Bias detection
Factuality check
Scope enforcement
Permission check
Tenant boundary check
```

---

## Fine-tuning & Training

### Training Data Pipeline

```text
Platform data
    ↓
PII removal
    ↓
Anonymization
    ↓
Quality filtering
    ↓
Synthetic data generation
    ↓
Training datasets
    ↓
Fine-tuning
    ↓
Model evaluation
    ↓
Model deployment
```

### Model Registry

```text
Base models
Fine-tuned models
Prompt-optimized models
Embedding models
Classification models
Prediction models
Versioning
A/B deployment
Canary releases
```

---

## Integration with Other MDs

- **MD-002 (Auth)**: identidade para IA.
- **MD-003 (Operational Context)**: contexto para prompts.
- **MD-004 (Dispatcher)**: ações de IA.
- **MD-005 (Event Store)**: histórico para RAG.
- **MD-010 (Security)**: segurança de dados de IA.
- **MD-016 (Auditoria)**: auditoria de execuções de IA.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core)**: portal consome IA.
- **MD-027 (AI Orchestration Platform)**: orquestração de agentes.
- **MD-029 (Digital Workplace)**: IA no workplace.
- **MD-032 (Unified Communication)**: IA na comunicação.
- **MD-034 (IAM)**: permissões de IA.
- **MD-035 (Security Trust Architecture)**: security para IA.
- **MD-038 (Integration Hub)**: IA via N8N.
- **MD-051 (Data Lake)**: fonte de dados para IA.

---

## Próximo MD recomendado

```text
MD-053 — Enterprise Search
```

Busca global da plataforma.

---

## Regras Canônicas

1. IA nunca acessa dados diretamente.
2. Toda execução de IA passa por IAM.
3. Toda execução é auditada.
4. RAG usa apenas fontes autorizadas.
5. Feature Store é única fonte de features.
6. Prompts são versionados.
7. Modelos são registrados.
8. Custos são rastreados por tenant.
9. PII é removido antes de enviar ao modelo.
10. Output é sanitizado antes de exibir.
11. Hallucination é mitigado.
12. Bias é monitorado.
13. Drift é detectado.
14. Fine-tuning usa dados próprios anonimizados.
15. IA respeita tenant isolation.
16. IA respeita permissões.
17. IA respeita compliance.
18. IA é explicável.
19. IA tem kill switch.
20. IA é governada.

---

## Proibições

São proibidos:

```text
IA acessando banco diretamente
Prompt sem registr0
Execução sem auditoria
Dado sensível sem PII masking
Modelo não registrado
Custo sem tracking
Hallucination sem mitigação
Output sem guardrails
Fine-tuning sem consentimento
Dado de outro tenant no prompt
IA sem kill switch
IA decidindo sem human-in-the-loop em casos críticos
```
