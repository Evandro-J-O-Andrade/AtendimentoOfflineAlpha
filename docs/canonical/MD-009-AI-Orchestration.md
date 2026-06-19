# MD-009 — AI Orchestration

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Definir a camada corporativa de IA como orquestração controlada, nunca como acesso direto a dados ou execução autônoma.

---

## Princípio Fundamental

```text
IA NÃO É BACKEND.
IA NÃO É FRONTEND.
IA É UM CANAL DE EXECUÇÃO CONTROLADO.
```

---

## Responsabilidades Da Camada De IA

IA executa através de:

```text
N8N (Orquestração)
OpenAI (LLMs)
RAG (Base De Conhecimento)
Agentes (Automação Dirigida)
Webhooks (Eventos Externos)
Workflows (Fluxos Corporativos)
```

---

## Regras Imutáveis

1. IA NÃO acessa banco diretamente.
2. IA executa ações através do Dispatcher canônico.
3. Toda ação gerada por IA gera evento.
4. Toda ação gerada por IA é auditada.
5. IA NÃO cria sessão própria.
6. IA NÃO define contexto operacional próprio.
7. IA NÃO substitui permissões.
8. IA opera dentro do tenant e contexto do usuário autenticado.
9. IA NÃO executa comandos destrutivos sem confirmação humana.
10. IA respeita isolamento multi-tenant absoluto.

---

## Fluxo Canônico De IA

```text
Usuário
  ↓
Portal / Aplicação
  ↓
IA Gateway (N8N)
  ↓
Agente IA
  ↓
Dispatcher (SP Canônica)
  ↓
Event Store
  ↓
Resposta Auditada
```

---

## Componentes

### N8N Gateway

Responsável por orquestração de fluxos.

```text
Recebe solicitação autenticada
Valida tenant e permissão
Direciona para agente ou workflow
Registra execução no Event Store
```

### Agentes IA

```text
Chat Corporativo
Assistente de Documentos
Análise de Dados Assistencial
Classificação de Chamados
Sugestão de Fluxos
Automação de Relatórios
```

### RAG - Base De Conhecimento

```text
Documentos Corporativos
Manuais de Procedimento
Contratos
Políticas Internas
Histórico de Eventos (somente metadados)
```

---

## Proibições

São proibidos:

```text
IA acessando tabelas diretamente
IA com permissão de escrita sem auditoria
IA criando eventos sem uuid_transacao
IA operando fora do tenant do usuário
IA ignorando permissões do perfil ativo
IA com acesso a dados de outros tenants
IA executando SQL
IA disparando e-mails sem registro
IA tomando decisões clínicas sem supervisão humana
IA desconsiderando Event Store
```

---

## Integração Com Event Store

Toda ação de IA gera evento canônico:

```json
{
  "evento_uuid": "UUID",
  "uuid_transacao": "UUID",
  "dominio": "IA",
  "acao": "IA_CHAT_RESPOSTA_GERADA",
  "id_sessao_usuario": 0,
  "id_tenant": 0,
  "id_unidade": 0,
  "id_local": 0,
  "payload": {
    "agente": "CHAT_CORPORATIVO",
    "modelo": "gpt-4",
    "tokens_entrada": 1200,
    "tokens_saida": 450
  },
  "resultado": {},
  "timestamp": "datetime"
}
```

---

## Lei Da IA Na Plataforma

```text
IA executa, não decide isoladamente.
IA sempre deixa rastro.
IA nunca acessa dados sem permissão.
IA é canal, não motor.
```

---

## Responsabilidades Do N8N

N8N é responsável por:

```text
Orquestração de workflows
Integração entre sistemas
Disparo de webhooks
Execução de automações
Canal entre IA e plataforma
Registro de execuções externas
```

N8N NÃO é responsável por:

```text
Regras de negócio assistencial
Autenticação
Autorização
Contexto operacional
Event Store própria
Banco de dados direto
