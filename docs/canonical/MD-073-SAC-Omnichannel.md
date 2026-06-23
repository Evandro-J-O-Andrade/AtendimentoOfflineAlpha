# MD-073 — SAC Omnichannel

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Atender o cliente em qualquer canal, sem repetir informações.

---

## Lei Fundamental

```text
Cliente não deve repetir informações.
```

---

## Canais

```text
Chat
WhatsApp
Email
Telefone
Social
App Mobile
Portal
Totem
Kiosk
```

---

## Componentes

### Tickets

Chamados de atendimento:

```text
Abertura
Classificação
Prioridade
Atribuição
Resolução
Encerramento
Reabertura
```

### Fila

Distribuição inteligente:

```text
Skill-based routing
SLA por canal
Prioridade por perfil
Balanceamento de carga
Escalonamento automático
```

### SLA

```text
Tempo de resposta
Tempo de resolução
Disponibilidade
Reabertura
Satisfação
```

### Base de Conhecimento

```text
FAQs
Soluções
Procedimentos
Integra com CRM e Customer 360
Enriquecida por IA
```

### Bots IA

```text
Triagem automática
Resposta instantânea
Escalonamento inteligente
Aprendizado contínuo
Roteamento por intenção
```

---

## Fluxo

```text
Cliente entra em qualquer canal
  ↓
Customer 360 identifica o cliente
  ↓
Histórico carregado automaticamente
  ↓
Ticket criado com contexto completo
  ↓
Bot IA resolve simples
  ↓
Humano resolve complexo
  ↓
Solução registrada na Base de Conhecimento
  ↓
Evento emitido para Customer 360
```

---

## Regras

1. Todo ticket nasce com contexto do Customer 360.
2. Nenhuma resposta humana sem acesso ao histórico.
3. Toda interação é registrada no Event Store.
4. Base de Conhecimento é alimentada automaticamente.
5. Satisfação é medida após cada interação.
6. Escalonamento é automático por SLA.

---

## Integrações

```text
MD-071 Customer 360
MD-072 CRM Enterprise
MD-034 IAM
MD-025 Event Store
MD-088 Global Notification Center
MD-081 AI Copilot
MD-082 Agent Marketplace
MD-089 Workflow Fabric
```

---

## Lei

```text
Cliente não deve repetir informações.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Omnicanalidade verdadeira
Unificação de contexto
SLA centralizado
Base de Conhecimento canônica
Bots IA inteligentes
```

Aplicações são responsáveis por:

```text
Disparar eventos de atendimento
Respeitar contratos de ticket
Usar APIs de busca na Base de Conhecimento
Atualizar status em tempo real
```

---

## Métricas

```text
TMA
TMO
SLA
FCR (First Contact Resolution)
CSAT
NPS
Churn por atendimento
Volume por canal
```
