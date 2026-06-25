# MAP-019 — AI Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de IA.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Global
```

## Objetivo
Definir a arquitetura completa da IA com bounded contexts, agregados, eventos, governança e custos.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Portal AI → HIS AI → CRM AI → RH AI → Finance AI
```

### LC-009 — IA é Transversal
```text
IA não é módulo isolado. IA é serviço compartilhado.
```

### LC-008 — Audit First
```text
Todo output de IA é auditável.
```

---

## Lei Canônica MAP-019-001
```text
IA serve, não governa.
```

---

## Hierarquia de Domínios
```text
AI Domain
├── Request Context
├── Agent Context
├── Knowledge Context
└── Prompt Context
```

---

## IA Core Architecture
```text
AI Core
│
├── Portal AI
├── HIS AI
├── CRM AI
├── RH AI
├── Finance AI
├── Analytics AI
└── Workflow AI
```

---

## Bounded Contexts

### Request Context
Responsável por: Request, Modelo, Tokens, Custo, Duração
Agregado: AIRequest

### Agent Context
Responsável por: Agente, Instruções, Tools, Capabilities, Versão
Agregado: Agent

### Knowledge Context
Responsável por: Conhecimento, Fonte, Atualização, Qualidade, Indexação
Agregado: Knowledge

### Prompt Context
Responsável por: Prompt, Template, Versão, Performance, Feedback
Agregado: Prompt

---

## Agregados Principais

### AIRequest Aggregate
```text
request_id (PK)
tenant_id (FK)
user_id (FK)
agent_id (FK)
modelo
provider
tokens_input
tokens_output
custo
duracao
status
criado_em
```

### Agent Aggregate
```text
agent_id (PK)
tenant_id (FK)
nome
instrucoes
tools_json
capabilities
ativo
criado_em
versao
```

### Knowledge Aggregate
```text
knowledge_id (PK)
tenant_id (FK)
fonte
conteudo
vetor_id
qualidade
atualizado_em
```

---

## Eventos Oficiais

### AIRequestIniciado
Payload: {request_id, agent_id, modelo, tenant_id}

### AIRequestCompletado
Payload: {request_id, resposta, tokens, custo}

### AICustoCalculado
Payload: {request_id, custo_total, provider}

### AgenteExecutado
Payload: {execucao_id, agent_id, user_id, sucesso}

### PromptAtualizado
Payload: {prompt_id, versao, alterado_por}

---

## Stored Procedures

### sp_ai_request_log
Input: {agent_id, prompt, modelo, user_id}
Output: {request_id}

### sp_ai_cost_calculate
Input: {tokens_input, tokens_output, modelo}
Output: {custo}

### sp_ai_agent_execute
Input: {agent_id, input, user_id}
Output: {execucao_id}

---

## APIs Oficiais

### /api/v1/ai/execute
POST - Executar agente
Body: {agent_id, input, context}

### /api/v1/ai/requests
GET - Histórico de requests

---

## Governança

### Rate Limiting
Por tenant, user, app, model.

### Cost Control
Budget limits, alerts, throttling, blocking.

---

## Regras Arquiteturais

### Transparency Rule
Todo output de IA é auditável.

### SP First Rule
Toda operação passa por Stored Procedure.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-005 — Portal | Portal AI |
| MAP-011 — HIS | HIS AI |
| MAP-012 — CRM | CRM AI |
| MD-081 — AI Copilot Framework | Copilot |
| MD-087 — Enterprise Search | Search |
| FRONT-024 — AI Experience | UX |
| FRONT-025 — AI Command Center | Command |