# MD-089 — Workflow Fabric (N8N Enterprise)

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Transformar N8N em infraestrutura nativa de automação da plataforma.

---

## Princípio Fundamental

```text
Automação é patrimônio da plataforma.

N8N não é ferramenta isolada.
N8N é tecido conectivo entre apps,
dados, IA e pessoas.
```

---

## Conecta

```text
Apps
IA
CRM
SAC
Marketplace
Financeiro
Social
Workplace
Analytics
Event Store
CRM
Billing
Documentos
Chamados
RH
```

---

## Recursos

### Workflows

```text
Visual builder
Código quando necessário
Versionamento
Testes
Agendamento
Triggers
Retry automático
Dead-letter queue
```

### Triggers

```text
Evento (Event Store)
Webhook
Tempo (cron)
Mudança de dados
Ação de usuário
Chegada de mensagem
Alteração de status
```

### Webhooks

```text
Entrada e saída
Validação de assinatura
Rate limiting
Retry com backoff
Mascaramento de payload
Log completo
```

### Filas

```text
Fila por tenant
Priorização
DLQ (Dead Letter Queue)
Replay
Monitoramento
Escalabilidade automática
```

### Agentes IA

```text
Agentes como steps
Memória de conversação
Contexto do tenant
Ferramentas disponíveis
Aprovação humana opcional
Log de raciocínio (chain of thought)
```

---

## Governança

```text
Workflows canônicos
Workflows customizados por tenant
Aprovação para produção
Sandbox de teste
Auditoria completa
Segurança de credenciais
Controle de acesso por workflow
```

---

## Integrações

```text
MD-025 Event-Store
MD-056 Hyperautomation-Platform
MD-057 Enterprise-Agent-Platform
MD-027 AI-Orchestration-Platform
MD-081 AI-Copilot-Framework
MD-082 Agent-Marketplace
MD-083 Prompt-Governance
MD-038 Integration-Hub
MD-034 IAM
MD-071 Customer-360
MD-072 CRM-Enterprise
MD-073 SAC-Omnichannel
```

---

## Regras

1. Nenhuma automação fora do Workflow Fabric.
2. Credenciais de integração são armazenadas no Vault.
3. Workflows customizados não sobrescrevem canônicos.
4. Execuções são auditáveis.
5. Falhas geram alertas e DLQ.
6. Replay é automático quando possível.
7. Alteração de workflow em produção requer aprovação.
8. Isolamento multi-tenant é obrigatório.

---

## Lei

```text
Automação é patrimônio da plataforma.

N8N é tecido conectivo.

Automação sem governança é risco.

Automação com governança é poder.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
N8N enterprise gerenciado
Node libraries canônicas
Segurança e vault de credenciais
Observabilidade de workflows
Governança e aprovação
Alta disponibilidade
```

Usuários são responsáveis por:

```text
Testar workflows antes de ativar
Monitorar execuções
Reportar falhas
Não compartilhar workflows sensíveis
Respeitar limites de execução
```

---

## Métricas

```text
Workflows ativos por tenant
Execuções por dia
Taxa de sucesso
Latência média
Falhas e DLQ itens
Tempo de execução médio
Tokens IA consumidos em workflows
Economia de horas humanas
Custo por execução
Adoção por tenant
```
