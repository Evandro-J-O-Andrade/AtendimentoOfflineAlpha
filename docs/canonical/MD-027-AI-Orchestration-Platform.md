# MD-027 — AI Orchestration Platform

## Status

Documento Canônico da Plataforma de IA da Plataforma Enterprise.

Este documento consolida e substitui a visão anterior de IA distribuída por domínio.

Substitui:

```text
MD-009 — AI Orchestration
IA_CANONICA.md
```

---

## Objetivo

Definir a Inteligência Artificial como serviço transversal, canônico e governado da plataforma.

A IA não é um recurso isolado do HIS, CRM, SAC, AVA, BI ou qualquer outra aplicação.

A IA é uma aplicação canônica da plataforma.

---

## Lei Fundamental

```text
A Inteligência Artificial é um serviço transversal da plataforma.

Nenhuma aplicação implementa IA própria.

Toda IA é registrada, auditada, monitorada e governada pelo AI Orchestration Platform.
```

---

## Posicionamento Canônico

```text
Portal Core
↓
AI Platform
↓
N8N
↓
Agentes
↓
Automações
↓
Apps
```

Consequência direta:

```text
IA não pertence ao HIS.

IA não pertence ao CRM.

IA não pertence ao SAC.

Todos pertencem à IA.
```

HIS, CRM, SAC, AVA, BI, Operacional, Financeiro e demais domínios podem consumir IA.

Nenhum domínio pode criar IA própria fora da plataforma canônica.

---

## Princípio Fundamental

```text
IA NÃO É BACKEND.

IA NÃO É FRONTEND.

IA NÃO É APP DE DOMÍNIO.

IA É CAMADA TRANSVERSAL DE ORQUESTRAÇÃO, CONHECIMENTO, AUTOMAÇÃO E GOVERNANÇA.
```

---

## Estrutura Canônica

O AI Orchestration Platform é composto por:

```text
AI Studio

Agent Registry

Prompt Registry

Model Registry

Knowledge Hub

RAG Engine

AI Workflow Engine

AI Analytics
```

---

## AI Studio

Responsável por:

```text
Prompts

Modelos

Testes

Versionamento lógico

Observabilidade
```

O AI Studio é a superfície oficial de criação, revisão, publicação e monitoramento de ativos de IA.

### Responsabilidades

```text
Criar prompts
Criar versões de prompts
Associar prompts a modelos
Definir parâmetros de geração
Registrar testes
Registrar avaliações
Registrar mudanças
Observar consumo
Observar custo
Observar latência
Observar qualidade
```

### Regras

1. Prompt só pode ser publicado pelo AI Studio.
2. Prompt precisa de versão lógica.
3. Prompt precisa de tenant ou escopo de tenant.
4. Prompt precisa de status explícito.
5. Prompt precisa de modelo padrão.
6. Prompt precisa de parâmetros auditáveis.
7. Prompt precisa de histórico de alterações.
8. Prompt não pode ser alterado diretamente por App.
9. Testes de prompt são obrigatórios antes da publicação.
10. Observabilidade de prompt alimenta AI Analytics.

### Status de Prompt

```text
DRAFT
REVIEW
APPROVED
PUBLISHED
DEPRECATED
ARCHIVED
```

---

## Agent Registry

Registro único de agentes.

Exemplos:

```text
Atendente IA
Suporte IA
Analista IA
Auditor IA
Financeiro IA
CRM IA
SAC IA
RH IA
Operacional IA
```

### Lei

```text
Nenhum agente existe fora do Registry.
```

### Responsabilidades

```text
Registrar agentes
Definir dono do agente
Definir tenant permitido
Definir capacidades
Definir permissões mínimas
Definir workflows disponíveis
Definir modelos permitidos
Definir limites de uso
Definir observabilidade
Definir ciclo de vida
```

### Modelo Canônico de Agente

```json
{
  "codigo": "SUPORTE_IA",
  "nome": "Suporte IA",
  "tenant": "GLOBAL",
  "categoria": "ATENDIMENTO",
  "owner": "SAC",
  "status": "PUBLISHED",
  "capabilities": [
    "CLASSIFICAR_CHAMADO",
    "SUGERIR_RESPOSTA",
    "RESUMIR_ATENDIMENTO"
  ],
  "workflows": [
    "SAC_CLASSIFICACAO_CHAMADO"
  ],
  "modelos_permitidos": [
    "OPENAI_GPT",
    "CLAUDE_ENTERPRISE"
  ],
  "observability": {
    "tokens": true,
    "custo": true,
    "latencia": true,
    "qualidade": true,
    "audit": true
  }
}
```

### Regras

1. Agente precisa estar no Agent Registry.
2. Agente precisa de dono.
3. Agente precisa de tenant ou escopo.
4. Agente precisa de capacidades declaradas.
5. Agente não executa ação sem permissão.
6. Agente não chama SP diretamente.
7. Agente não acessa banco diretamente.
8. Agente não cria evento fora do Event Store.
9. Agente não opera fora do contexto do usuário autenticado.
10. Agente precisa ser observável.

---

## Prompt Registry

Cadastro oficial de prompts.

### Campos obrigatórios

```text
codigo
nome
tenant
categoria
modelo
temperatura
tokens_maximos
status
```

### Modelo Canônico

```json
{
  "codigo": "SAC_RESUMO_ATENDIMENTO",
  "nome": "Resumo de Atendimento SAC",
  "tenant": "GLOBAL",
  "categoria": "SAC",
  "modelo": "OPENAI_GPT",
  "temperatura": 0.2,
  "tokens_maximos": 1200,
  "status": "PUBLISHED",
  "versao": 3,
  "owner": "SAC",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Regras

1. Código de prompt deve ser único por tenant.
2. Prompt deve declarar categoria.
3. Prompt deve declarar modelo padrão.
4. Prompt deve declarar temperatura.
5. Prompt deve declarar limite de tokens.
6. Prompt deve declarar status.
7. Prompt deve ter versão lógica.
8. Prompt deve ter owner.
9. Prompt deve ter histórico.
10. Prompt não pode ser invocado diretamente por App.

---

## Model Registry

Cadastro oficial de modelos e provedores.

### Suporte obrigatório

```text
OpenAI
Gemini
Claude
OpenRouter
Local LLM
```

### Lei

```text
Modelo é desacoplado do Agente.
```

### Responsabilidades

```text
Registrar provedor
Registrar modelo
Registrar versão
Registrar capacidade
Registrar custo estimado
Registrar limites
Registrar região
Registrar política de uso
Registrar status
```

### Modelo Canônico

```json
{
  "codigo": "OPENAI_GPT",
  "provedor": "OPENAI",
  "modelo": "gpt-4.1",
  "versao": "stable",
  "status": "ACTIVE",
  "capacidades": [
    "CHAT",
    "RAG",
    "CLASSIFICACAO",
    "EXTRACAO"
  ],
  "custo_estimado": {
    "entrada": "USD_POR_MILHAO_TOKENS",
    "saida": "USD_POR_MILHAO_TOKENS"
  },
  "limites": {
    "tokens_maximos_contexto": 0,
    "tokens_maximos_saida": 0,
    "requests_por_minuto": 0
  }
}
```

### Regras

1. Modelo pertence ao Model Registry.
2. Agente referencia modelo.
3. Agente não contém segredo de provedor.
4. Prompt pode sugerir modelo, mas não carrega credencial.
5. Credencial de provedor pertence à infraestrutura segura.
6. Modelo precisa de status.
7. Modelo precisa de limites.
8. Modelo precisa de estimativa de custo.
9. Modelo precisa de política de uso.
10. Modelo precisa ser observável por AI Analytics.

---

## Knowledge Hub

Base de conhecimento canônica.

### Fontes

```text
Documentos
Wiki
AVA
CRM
SAC
Manuais
Políticas
Procedimentos
```

### Responsabilidades

```text
Ingestar fontes
Classificar fontes
Versionar fontes
Indexar fontes
Controlar tenant
Controlar permissão
Controlar ciclo de vida
Controlar proveniência
Controlar qualidade
```

### Regras

1. Knowledge Hub é a fonte oficial de conhecimento para RAG.
2. Documento precisa de tenant.
3. Documento precisa de origem.
4. Documento precisa de versão.
5. Documento precisa de status.
6. Documento precisa de permissão de leitura.
7. Documento precisa de hash para integridade.
8. Documento precisa de trilha de indexação.
9. Documento não pode ser indexado sem owner.
10. Documento não pode ser consultado fora do tenant/contexto autorizado.

---

## RAG Engine

Motor canônico de recuperação aumentada.

Responsável por:

```text
Embeddings
Vetores
Busca semântica
Contexto
```

### Fluxo

```text
Consulta do Agente
↓
Validação de sessão
↓
Validação de tenant
↓
Validação de contexto
↓
Busca semântica
↓
Filtragem por permissão
↓
Montagem de contexto
↓
Prompt
↓
Modelo
↓
Resposta
↓
Evento
```

### Regras

1. RAG nunca acessa banco diretamente.
2. RAG só consulta Knowledge Hub e fontes autorizadas.
3. RAG respeita tenant.
4. RAG respeita permissão.
5. RAG respeita contexto operacional.
6. RAG precisa registrar documento recuperado.
7. RAG precisa registrar score de relevância.
8. RAG precisa registrar versão do índice.
9. RAG precisa registrar fonte e timestamp.
10. RAG precisa alimentar AI Analytics.

### Proibições

```text
RAG lendo tabela diretamente

RAG ignorando tenant

RAG ignorando permissão

RAG sem origem do documento

RAG sem score

RAG sem auditoria

RAG com dado cross-tenant
```

---

## AI Workflow Engine

Camada de integração direta com N8N.

Permite:

```text
Agente
↓
Workflow
↓
N8N
↓
Integração
↓
Resultado
```

### Responsabilidades

```text
Registrar workflows de IA
Associar agentes a workflows
Disparar N8N
Receber resultado
Validar resultado
Registrar execução
Registrar erro
Registrar retry
Registrar auditoria
```

### Regras

1. Workflow de IA precisa estar registrado.
2. Workflow precisa de owner.
3. Workflow precisa de tenant.
4. Workflow precisa de status.
5. Workflow precisa de versão.
6. Workflow precisa de permissões mínimas.
7. Workflow não executa regra de negócio.
8. Workflow não acessa banco diretamente.
9. Workflow não substitui Dispatcher.
10. Workflow precisa gerar evento.

### Fluxo canônico

```text
Agente
↓
AI Workflow Engine
↓
N8N
↓
Webhook assinado
↓
Dispatcher
↓
SP
↓
Event Store
↓
Resposta auditada
```

---

## N8N

N8N é a camada de automação e integração operacional da IA.

N8N não é dono da IA.

N8N executa fluxos aprovados pelo AI Orchestration Platform.

### Responsabilidades

```text
Orquestrar fluxos
Integrar sistemas externos
Disparar webhooks
Executar automações
Registrar execução
Registrar falhas
Registrar retry
```

### Proibições

```text
N8N acessando banco diretamente

N8N recebendo segredos no frontend

N8N executando regra de negócio

N8N substituindo Dispatcher

N8N criando evento fora do Event Store

N8N operando sem tenant

N8N operando sem assinatura

N8N executando workflow não registrado
```

---

## AI Analytics

Portal Analytics recebe métricas canônicas de IA.

### Métricas obrigatórias

```text
Tokens consumidos
Custos
Latência
Modelos utilizados
Usuários
Apps
Tenants
```

### Métricas complementares

```text
Agentes
Prompts
Versões
Workflows
N8N
RAG
Vetores
Fontes recuperadas
Erros
Retries
Qualidade
Avaliações
Human-in-the-loop
```

### Modelo Canônico de Métrica

```json
{
  "tenant_id": 0,
  "app": "SAC",
  "agente": "SUPORTE_IA",
  "prompt": "SAC_RESUMO_ATENDIMENTO",
  "modelo": "OPENAI_GPT",
  "workflow": "SAC_CLASSIFICACAO_CHAMADO",
  "tokens_entrada": 0,
  "tokens_saida": 0,
  "custo_estimado": 0,
  "latencia_ms": 0,
  "usuario_id": "UUID",
  "sessao_id": "UUID",
  "timestamp": "datetime"
}
```

### Regras

1. AI Analytics deriva do Event Store.
2. AI Analytics não aceita métrica manual sem origem.
3. Métrica de IA precisa de tenant.
4. Métrica de IA precisa de agente.
5. Métrica de IA precisa de prompt.
6. Métrica de IA precisa de modelo.
7. Métrica de IA precisa de usuário ou identidade técnica.
8. Métrica de IA precisa de sessão ou execução.
9. Métrica de IA precisa de custo.
10. Métrica de IA precisa de latência.

---

## Segurança

A IA herda integralmente a segurança da plataforma.

### Controles obrigatórios

```text
JWT
HttpOnly
Refresh Token
MFA
Google Authenticator
Webhook Signing
Audit Trail
Event Store
```

### Regras de segurança

1. IA usa sessão canônica.
2. IA usa tenant da sessão.
3. IA usa contexto operacional quando aplicável.
4. IA usa permissões resolvidas pelo IAM.
5. IA usa Dispatcher para ação.
6. IA usa Event Store para auditoria.
7. IA não recebe segredo no frontend.
8. IA não recebe API key de provedor no frontend.
9. IA não armazena token de provedor em localStorage.
10. IA não executa operação sem auditoria.

### Webhook de IA

Todo webhook de IA precisa de:

```text
Signature
Timestamp
Nonce
Replay Protection
Tenant
Workflow
Execução
```

### Regras de Webhook

1. Webhook aberto é proibido.
2. Webhook sem assinatura é ignorado.
3. Webhook sem timestamp expirado é rejeitado.
4. Webhook com nonce repetido é rejeitado.
5. Webhook sem tenant é rejeitado.
6. Webhook sem workflow registrado é rejeitado.
7. Webhook sem execução registrada é rejeitado.
8. Webhook com payload inválido não executa ação.

---

## Eventos Canônicos de IA

Toda ação da IA gera evento.

### Eventos mínimos

```text
AI_PROMPT_EXECUTADO
AI_AGENTE_INICIADO
AI_WORKFLOW_DISPARADO
AI_DOCUMENTO_INDEXADO
AI_MODELO_ALTERADO
```

### Eventos complementares

```text
AI_AGENTE_CRIADO
AI_AGENTE_PUBLICADO
AI_PROMPT_CRIADO
AI_PROMPT_PUBLICADO
AI_MODELO_CRIADO
AI_KNOWLEDGE_INGESTADO
AI_RAG_BUSCA_EXECUTADA
AI_WORKFLOW_APROVADO
AI_WORKFLOW_FALHOU
AI_WORKFLOW_REEXECUTADO
AI_CUSTO_CALCULADO
AI_AVALIACAO_REGISTRADA
AI_HUMAN_APPROVAL_SOLICITADO
AI_HUMAN_APPROVAL_APROVADO
AI_HUMAN_APPROVAL_REJEITADO
```

### Modelo de Evento

```json
{
  "evento_uuid": "UUID",
  "execucao_uuid": "UUID",
  "dominio": "IA",
  "acao": "AI_PROMPT_EXECUTADO",
  "agente": "SUPORTE_IA",
  "prompt": "SAC_RESUMO_ATENDIMENTO",
  "modelo": "OPENAI_GPT",
  "workflow": "SAC_CLASSIFICACAO_CHAMADO",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "payload": {
    "tokens_entrada": 0,
    "tokens_saida": 0,
    "latencia_ms": 0,
    "custo_estimado": 0,
    "rag_sources": []
  },
  "resultado": {},
  "timestamp": "datetime"
}
```

### Regras de evento

1. Evento de IA precisa de execução.
2. Evento de IA precisa de agente.
3. Evento de IA precisa de prompt.
4. Evento de IA precisa de modelo.
5. Evento de IA precisa de tenant.
6. Evento de IA precisa de sessão ou identidade técnica.
7. Evento de IA precisa de tokens.
8. Evento de IA precisa de custo.
9. Evento de IA precisa de latência.
10. Evento de IA precisa de resultado ou erro.

---

## Integração com o Portal

No App Registry:

```text
AI_STUDIO
AI_AGENTS
AI_ANALYTICS
AI_WORKFLOWS
AI_KNOWLEDGE
```

Tudo nasce dentro do Portal Core.

### Registro no App Registry

```json
{
  "codigo": "AI_STUDIO",
  "nome": "AI Studio",
  "dominio": "IA",
  "rota": "/apps/ai-studio",
  "contexto_obrigatorio": false,
  "auth_required": true,
  "permissoes": [
    "AI_STUDIO.ACESSAR",
    "AI_PROMPT.CRIAR",
    "AI_PROMPT.PUBLICAR"
  ],
  "sp_namespace": "AI",
  "event_namespace": "IA",
  "dashboards": [
    "AI_ANALYTICS_GERAL",
    "AI_CUSTOS",
    "AI_QUALIDADE"
  ],
  "entrypoints": [
    "UI",
    "API",
    "DISPATCHER"
  ],
  "tenant_scope": "MULTI_TENANT"
}
```

### Regras

1. App de IA precisa estar no App Registry.
2. App de IA precisa de permissões declaradas.
3. App de IA precisa de event namespace.
4. App de IA precisa de dashboard no Analytics.
5. App de IA precisa respeitar Design System.
6. App de IA precisa usar Auth canônico.
7. App de IA precisa usar Dispatcher canônico.
8. App de IA não pode criar roteamento próprio.
9. App de IA não pode manter analytics isolado.
10. App de IA não pode criar agente fora do Agent Registry.

---

## Fluxo de Execução Canônico

```text
Usuário
↓
Portal Core
↓
App de IA
↓
Sessão
↓
Tenant
↓
Contexto
↓
Permissão
↓
Agente
↓
Prompt Registry
↓
Model Registry
↓
Knowledge Hub
↓
RAG Engine
↓
AI Workflow Engine
↓
N8N
↓
Dispatcher
↓
SP
↓
Event Store
↓
AI Analytics
```

### Regras de execução

1. Usuário inicia dentro do Portal.
2. IA usa sessão ativa.
3. IA valida tenant.
4. IA valida permissão.
5. IA valida agente.
6. IA valida prompt.
7. IA valida modelo.
8. IA valida Knowledge Hub.
9. IA valida workflow.
10. IA executa ação pelo Dispatcher.
11. IA registra evento.
12. IA alimenta Analytics.

---

## Human-in-the-Loop

Operações sensíveis exigem confirmação humana.

### Exemplos

```text
Aprovação financeira
Resposta clínica
Cancelamento de contrato
Alteração de cadastro crítico
Envio massivo
Decisão regulatória
Ação destrutiva
```

### Regras

1. Ação sensível precisa de aprovação humana.
2. Aprovação precisa de auditoria.
3. Aprovação precisa de identidade.
4. Aprovação precisa de timestamp.
5. Aprovação precisa de contexto.
6. Aprovação precisa de payload original.
7. Aprovação precisa de decisão explícita.
8. Aprovação precisa gerar evento.
9. Reprovação precisa gerar evento.
10. Expiração de aprovação precisa gerar evento.

---

## Governança de IA

### Governança obrigatória

```text
Cadastro de agentes
Cadastro de prompts
Cadastro de modelos
Cadastro de workflows
Cadastro de fontes de conhecimento
Cadastro de permissões
Cadastro de limites
Cadastro de custos
Cadastro de owners
Cadastro de avaliações
```

### Ciclo de vida

```text
DRAFT
REVIEW
APPROVED
PUBLISHED
MONITORING
DEPRECATED
ARCHIVED
```

### Regras

1. IA precisa de owner.
2. IA precisa de responsável técnico.
3. IA precisa de responsável de negócio.
4. IA precisa de limites de uso.
5. IA precisa de orçamento ou teto de custo.
6. IA precisa de política de retenção.
7. IA precisa de plano de rollback.
8. IA precisa de observabilidade.
9. IA precisa de avaliação contínua.
10. IA precisa de auditoria.

---

## Evolução e MAPs

Os MAPs atuais não são um fim em si mesmos.

Eles só devem ser revisitados quando ocorrer uma destas situações:

```text
1. Descobrimos algo novo no dump.
2. Encontramos duplicação ontológica.
3. Existe oportunidade de consolidar domínios.
4. Conseguimos criar uma versão mais robusta.
5. O Portal Core exige reorganização estrutural.
```

Se os MAPs atuais já representam corretamente os 90% do banco, não faz sentido parar a evolução da plataforma para reescrevê-los.

O caminho natural é continuar.

### Regras para evolução

1. IA não bloqueia evolução dos MAPs.
2. MAPs não bloqueiam IA.
3. IA nasce como camada transversal.
4. MAPs continuam representando o legado e o banco.
5. AI Orchestration Platform representa o futuro da plataforma.
6. Integração entre MAPs e IA acontece por eventos, ações e contexto.
7. Nenhuma IA depende de tabela direta do legado.
8. Nenhuma IA depende de SP direta do legado.
9. IA usa Dispatcher e Event Store.
10. IA pode evoluir mesmo com MAPs congelados.

---

## Integração Com Outros MDs

- **MD-002 (Auth)**: identidade, sessão, JWT, refresh token e MFA.
- **MD-003 (Operational Context)**: tenant, unidade, local, perfil e contexto operacional.
- **MD-004 (Dispatcher)**: entrada oficial de ações executáveis.
- **MD-005 (Event Store)**: auditoria e histórico de execuções.
- **MD-009 (AI Orchestration)**: documento anterior substituído por este MD-027.
- **MD-010 (Security)**: base anterior de segurança.
- **MD-014 / MD-019 (App Registry)**: apps de IA registradas no Portal.
- **MD-016 (Auditoria)**: rastreabilidade e imutabilidade.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core Architecture)**: Portal como origem de todas as apps.
- **MD-021 (Legacy Adapter Layer)**: integração com legado sem acesso direto.
- **MD-022 (Legacy Action Mapping)**: mapeamento de ações legadas para ações canônicas.
- **MD-023 (Action Registry Engine)**: ações executáveis usadas por agentes e workflows.
- **MD-025 (Event Store Core)**: imutabilidade histórica dos eventos.
- **MD-026 (Security Zero Trust)**: zero trust, webhook signing, sessão e tenant.
- **MD-033 (Analytics Governance)**: AI Analytics, custos, tokens, latência e qualidade.
- **MD-034 (Identity Access Management)**: usuários, apps, escopos, perfis dinâmicos e permissões.

---

## Proibições

São proibidos:

```text
IA pertencendo ao HIS

IA pertencendo ao CRM

IA pertencendo ao SAC

App implementando IA própria

Agente fora do Agent Registry

Prompt fora do Prompt Registry

Modelo fora do Model Registry

Conhecimento fora do Knowledge Hub

RAG sem permissão

RAG sem tenant

RAG sem score

RAG sem fonte

RAG sem auditoria

Workflow fora da AI Workflow Engine

N8N acessando banco diretamente

N8N executando regra de negócio

N8N sem assinatura

IA executando SQL

IA acessando tabela diretamente

IA com API key no frontend

IA com token de provedor no frontend

IA sem Event Store

IA sem AI Analytics

IA sem owner

IA sem versão

IA sem observabilidade

IA sem custo

IA sem latência

IA sem auditoria

IA cross-tenant

IA com decisão destrutiva sem aprovação humana
```

---

## Regras Canônicas

1. IA é serviço transversal da plataforma.
2. Portal Core é a origem de todas as apps de IA.
3. Nenhuma aplicação implementa IA própria.
4. Todo agente pertence ao Agent Registry.
5. Todo prompt pertence ao Prompt Registry.
6. Todo modelo pertence ao Model Registry.
7. Todo conhecimento pertence ao Knowledge Hub.
8. Todo RAG respeita tenant, permissão e contexto.
9. Todo workflow de IA passa por AI Workflow Engine.
10. N8N é executor de automação, não dono da IA.
11. Toda ação de IA gera evento.
12. Toda execução de IA alimenta AI Analytics.
13. Toda IA usa Auth canônico.
14. Toda IA usa Dispatcher canônico.
15. Toda IA respeita Event Store.
16. Toda IA respeita Zero Trust.
17. Toda IA respeita Human-in-the-Loop.
18. Toda IA tem owner.
19. Toda IA tem versão.
20. Toda IA tem custo observável.

---

## Próximo MD recomendado

```text
MD-031 — Marketplace & Ecosystem
```

Transforma a plataforma em ecossistema extensível.

---

## Próximo MD após Marketplace

```text
MD-032 — Unified Communication & Engagement Platform
```

Communication Hub da plataforma.

---

## Lei Final

```text
Portal Core é a porta.

AI Orchestration Platform é a inteligência transversal.

N8N é o braço de automação.

Agentes são registrados.

Prompts são versionados.

Modelos são desacoplados.

Conhecimento é governado.

RAG é auditável.

Workflows são observáveis.

Analytics mede tudo.

Event Store registra tudo.

Nenhuma aplicação cria IA própria.

Toda IA nasce do Portal.
```

---
