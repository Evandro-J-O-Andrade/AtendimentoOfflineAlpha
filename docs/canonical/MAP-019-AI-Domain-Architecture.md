# MAP-019 — AI Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de IA.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Objetivo
Definir arquitetura de IA com governança e custos.

---

## Bounded Contexts

### Request Context
```text
Request
Modelo
Tokens
Custo
Duração
```

### Agent Context
```text
Agente
Instruções
Tools
Capabilities
```

### Knowledge Context
```text
Conhecimento
Fonte
Atualização
Qualidade
```

### Prompt Context
```text
Prompt
Template
Versão
Performance
```

---

## Agregados

### AIRequest Aggregate
```text
request_id
tenant_id
user_id
agent_id
modelo
tokens_input
tokens_output
custo
duracao
```

### Agent Aggregate
```text
agent_id
tenant_id
nome
instrucoes
tools_json
ativo
```

---

## Eventos Oficiais

### AIRequestIniciado
### AIRequestCompletado
### AICustoCalculado
### AgenteExecutado
### PromptAtualizado

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-081 — AI Copilot Framework | Copilot |
| MD-087 — Enterprise Search | Search |
| FRONT-024 — AI Experience | UX |
| FRONT-025 — AI Command Center | Command |