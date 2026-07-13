# MAP-019 — AI Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de IA.

```text
FREEZE (Ciclo Arquitetural 1)
Congelado junto com LEI 23–26 (000-CONSTITUICAO-PLATAFORMA.md, Título XV).
Alteração exige ADR + aprovação do Arquiteto Chefe.
```

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

### Same Runtime Rule (LEI 23)
Agentes de IA consomem a plataforma pelo mesmo Runtime
das interfaces humanas. É proibido contornar o Kernel,
os contratos ou as SPs canônicas.

---

## Domínio de Integração com Agentes (ai_agent)

A plataforma prevê domínio específico para controlar agentes
inteligentes. Essas estruturas NÃO armazenam a inteligência da IA;
controlam autenticação, autorização, contexto, auditoria, ferramentas
e rastreabilidade.

### Entidades
```text
ai_agent            — Registro do agente
ai_agent_session    — Sessão ativa do agente
ai_agent_permission — Permissões do agente
ai_agent_context    — Contexto da execução
ai_agent_registry   — Catálogo de agentes disponíveis
ai_agent_audit      — Auditoria de chamadas
ai_agent_execution  — Execução de tarefa pelo agente
ai_agent_tool       — Ferramentas (tools) expostas ao agente
ai_agent_memory     — Memória de longo prazo do agente
```

### Caminho Obrigatório de Acesso (LEI 23 / LEI 25 / LC-AI-002)
```text
IA / Agente
   ↓
MCP / API (AI API, MCP API)
   ↓
AI Runtime
   ↓
Capability Resolver → Runtime Resolver
   ↓
Runtime alvo (Portal / Farmácia / Estoque / ...)
   ↓
Master
   ↓
Dispatcher
   ↓
Executors
   ↓
Stored Procedures
   ↓
Banco Canônico
```

### Princípio
```text
Agente é registrado (ai_agent_registry).
Agente é autenticado e autorizado (ai_agent_permission).
Agente opera dentro de contexto (ai_agent_context).
Agente usa ferramentas via contrato (ai_agent_tool).
Toda chamada é rastreada (ai_agent_audit, ai_agent_execution).
Nenhuma chamada toca o banco fora do Runtime canônico.
```

---

## AI Runtime (LEI 24 / LEI 25)

AI Runtime NÃO é uma IA. É o Runtime que conversa com IAs.
Todo agente externo (Claude, OpenAI, Gemini, automação) entra
pelo AI Runtime e segue o mesmo fluxo de um usuário.

O AI Runtime NÃO conhece o Portal. O Portal é apenas mais um
Runtime da plataforma. O AI Runtime descobre o Runtime de destino
via Runtime Resolver.

### Fluxo do AI Runtime (LEI 25)
```text
AI
 ↓
AI Runtime
 ↓
Capability Resolver
 ↓
Runtime Resolver
 ↓
 ┌──────────────┼───────────────┐
 │              │               │
Portal      Farmácia        Estoque
Runtime      Runtime         Runtime
 │              │               │
 └──────────────┼───────────────┘
                ↓
          Master Layer
                ↓
           Dispatcher
                ↓
            Executors
                ↓
                SP
                ↓
         Banco Canônico
```

### MCP é apenas mais um cliente
```text
Claude MCP  → AI Runtime → Runtime Resolver → Runtime alvo → SP
OpenAI MCP  → AI Runtime → Runtime Resolver → Runtime alvo → SP
Gemini      → AI Runtime → Runtime Resolver → Runtime alvo → SP
```

Todos iguais. Nenhum MCP toca o banco diretamente.
O Portal Runtime deixa de ser obrigatório.

---

## Runtime Registry (LEI 25)

O sistema descobre dinamicamente quais runtimes existem.
O Runtime Resolver usa este registro para rotear.

```text
Portal Runtime
Auth Runtime
Context Runtime
Notification Runtime
Workflow Runtime
Integration Runtime
Estoque Runtime
Farmácia Runtime
Financeiro Runtime
Laboratório Runtime
AI Runtime
```

---

## Capability Registry (LEI 24 p6 / LEI 25 p2)

Domínio canônico. A IA NÃO conhece o sistema inteiro nem a SP.
Ela conhece apenas a capacidade. O Runtime resolve o resto.

### Hierarquia Canônica
```text
Capability
   ↓
Feature
   ↓
Action
   ↓
Tool
   ↓
Endpoint
   ↓
SP
```

### Exemplo
```text
Consultar Estoque
   ↓
GET /estoque
   ↓
sp_master_estoque
   ↓
sp_executor_estoque_get
```

### Descoberta
```text
GET /runtime/capabilities
```

Resposta:
```json
{
  "modules": ["Portal","Farmácia","Estoque","Financeiro"],
  "actions": ["Consultar Estoque","Criar Atendimento","Dispensar Medicamento"]
}
```

A IA nunca descobre capacidades sozinha. O Runtime entrega,
filtrado por tenant, contexto e permissão.

---

## Tool Registry (LEI 24 p6 / LEI 25 p3)

Ferramentas NÃO são codificadas em cada IA. São registradas no Runtime.
Cada Tool conhece sua própria governança:

```text
Nome
Descrição
Domínio
Runtime
Procedure
Contrato
Permissão
Tenant
Versão
Status
Timeout
Auditoria
```

Exemplos:
```text
tool_get_patient
tool_create_ticket
tool_search_stock
tool_dispense
tool_open_glpi
tool_generate_report
```

O Runtime informa quais ferramentas a IA pode usar, conforme:
tenant, contexto, permissões e perfil.

---

## AI Session (LEI 24 p7)

Toda IA possui sessão, exatamente como um usuário humano.

```text
Sessão IA
   ↓
Quem chamou (tenant / app / usuário)
   ↓
Tenant
   ↓
Contexto
   ↓
Permissões
   ↓
Auditoria
   ↓
Execution Trace
   ↓
Conversation Id
   ↓
Execução
```

Execution Trace + Conversation Id permitem responder:
* Quem pediu?
* Qual IA executou?
* Qual ferramenta utilizou?
* Qual procedure chamou?
* Quanto tempo demorou?
* Qual o id da conversa?

Toda ação de IA é rastreável e auditável como ação humana.

---

## Memória da IA (Separação de Verdade)

Memória de conversa ≠ dados do sistema.

```text
Memória da IA (temporária):
  objetivo da tarefa, histórico da interação.
  NUNCA é fonte da verdade.

Fonte oficial:
  Banco Canônico, acessado pelo Runtime.
```

Isso garante que IAs diferentes consultem exatamente o mesmo
estado do sistema, sem inconsistências.

---

## Lei da Execução Canônica (LEI 26)

Toda capacidade descoberta é executada pelo mesmo pipeline.
Nenhum cliente pula etapas.

### Pipeline Canônico de Execução
```text
Capability
   ↓
Action
   ↓
Contract
   ↓
Runtime
   ↓
Master
   ↓
Guardião (Permission + Context + Tenant + Feature)
   ↓
Dispatcher
   ↓
Executor
   ↓
Stored Procedure
   ↓
Banco Canônico
   ↓
Eventos
   ↓
Auditoria
   ↓
Resposta
```

### Capability não executa
```text
Capability apenas informa:
  - existe
  - quem pode usar
  - qual contrato utiliza
Quem executa é o Runtime.
```

### Runtime resolve (cliente não sabe a SP)
Entrada exemplo:
```json
{
  "capability": "farmacia.dispensar",
  "contexto": "...",
  "tenant": "...",
  "payload": { }
}
```

Resolução interna (opaca para o cliente):
```text
Capability → Action → Runtime → Master → Executor
```

Sem que o cliente saiba qual SP foi utilizada.

---

## Catálogo Canônico (LEI 26)

Documentação tratada como catálogo navegável por capacidade.

```text
Capability
   ├── Runtime
   ├── Contrato
   ├── API
   ├── Evento
   ├── SP Master
   ├── Executor
   ├── Permissões
   ├── BR
   ├── MD
   ├── MAP
   └── FRONT
```

---

## Engenharia Orientada por Capacidades (LEI 26)

A capacidade é a unidade de engenharia. Novo módulo
NUNCA começa por tabela. Começa por Capability.

```text
Capacidade
   ↓
MD
   ↓
BR
   ↓
MAP
   ↓
Contrato
   ↓
Runtime
   ↓
Master
   ↓
Executor
   ↓
SQL
   ↓
Frontend
   ↓
MCP
   ↓
IA
```

---

## Graph Runtime — Visão de Futuro (LEI 26)

Banco vivo evolui de documentação de estrutura física para
representação do conhecimento arquitetural (Knowledge Graph
→ Graph Runtime). Relações navegáveis:

```text
Capability
   ├── usa Runtime
   ├── usa Contrato
   ├── chama Master
   ├── chama Executor
   ├── executa SP
   ├── altera Tabelas
   ├── gera Eventos
   ├── possui BRs
   ├── possui MDs
   └── possui Testes
```

Permite perguntas sem inferência, apenas navegação:
* Quais capacidades são impactadas se esta tabela mudar?
* Quais SPs implementam esta capability?
* Quais BRs e MDs precisam ser atualizados?
* Quais runtimes e contratos são afetados?

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