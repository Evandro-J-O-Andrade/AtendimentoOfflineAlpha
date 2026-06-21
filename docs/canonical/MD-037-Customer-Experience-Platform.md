# MD-037 — Customer Experience Platform

## Status

Documento Canônico da Experiência do Cliente da Plataforma Enterprise.

---

## Objetivo

Unificar CRM, SAC, Portal, Checkout em uma única camada de CX.

Customer journey end-to-end.

Jornada: Lead → Proposta → Venda → Onboarding → Suporte → Renovação.

---

## Lei Fundamental

```text
Cliente não é ticket.

Cliente é jornada.

Jornada é contínua.

Contínua é personalizada.
```

---

## Customer Journey Stages

```text
Lead
Proposta
Venda
Onboarding
Suporte
Renovação
```

---

## CX Engine

Camada única de experiência:

```text
Unified profile
Journey orchestration
Omnichannel support
Personalization
Recommendations
NPS tracking
Feedback loops
```

---

## CRM Integration

Unifica:

```text
Leads
Opportunities
Accounts
Contacts
Activities
Forecast
Pipeline
Quotas
```

### Modelo Canônico de Lead

```json
{
  "lead_uuid": "UUID",
  "tenant_id": 0,
  "source": "WEBSITE",
  "status": "NEW",
  "score": 0,
  "owner_id": "UUID",
  "contact": {},
  "journey_stage": "LEAD",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

### Journey Stages Canônicos

```json
{
  "stage": "LEAD|PROPOSTA|VENDA|ONBOARDING|SUPORTE|RENOVACAO",
  "entered_at": "datetime",
  "duration_days": 0,
  "next_stage": "string",
  "probability": 0.0,
  "assigned_to": "UUID",
  "touchpoints": []
}
```

---

## SAC Integration

Unifica:

```text
Tickets
Chamados
Incidentes
Problems
Changes
Requests
SLA
NPS
Satisfação
FAQ
Chatbot
WhatsApp
Email
```

---

## Portal Integration

Cliente no Portal:

```text
Login único
Dashboard cliente
Meus contratos
Meus tickets
Meus cursos
Meus documentos
Meus pagamentos
Histórico de interações
Status de solicitações
Notificações personalizadas
```

### Self-Service

```text
Abertura de chamado
Acompanhamento de ticket
Upload de documentos
Agendamento de reunião
Renovação de contrato
Solicitação de suporte
Consulta de NPS
Atualização de cadastro
```

---

## Commerce Integration

Checkout e pagamento:

```text
Carrinho
Pagamento
Assinatura
Faturas
Cobrança
Promoções
Cupons
Fretes
Métodos de pagamento
Parcelamento
Nota fiscal
Recibo automático
```

---

## Omnichannel

Canais integrados:

```text
Portal Cliente
Email
WhatsApp
Telefone (URA)
Chat (live + bot)
Redes Sociais
App Mobile
SAC Presencial
Chatbot IA
```

---

## Personalization Engine

Personaliza:

```text
Conteúdo
Ofertas
Comunicação
Jornada
Recomendações
Experiência
Interface
Horário de contato
Canal preferido
Frequência de comunicação
```

### Perfil Unificado

```json
{
  "cliente_uuid": "UUID",
  "tenant_id": 0,
  "preferences": {
    "canal_preferido": "WHATSAPP",
    "horario_preferido": "COMERCIAL",
    "frequencia": "SEMANAL",
    "idioma": "pt-BR",
    "timezone": "America/Sao_Paulo"
  },
  "interests": [],
  "journey_stage": "LEAD",
  "nps_score": 0,
  "lifetime_value": 0,
  "churn_risk": "LOW|MEDIUM|HIGH"
}
```

---

## Feedback Loops

Coleta:

```text
NPS
CSAT
CES
Reviews
Ratings
Sentiment
Surveys
Interviews
Social mentions
Support satisfaction
Product feedback
```

### Métricas Canônicas

```text
NPS: -100 a +100
CSAT: 1-5 escala
CES: 1-7 escala
Churn rate
Retention rate
Lifetime value
Customer effort score
Resolution time
First response time
SLA compliance
```

---

## Apps Registradas

```text
CX_PLATFORM
CUSTOMER_HUB
JOURNEY_ENGINE
PERSONALIZATION
NPS_TRACKER
FEEDBACK_CENTER
CUSTOMER_PORTAL
CLIENTE_DASHBOARD
OMNICHANNEL
SELF_SERVICE
```

---

## Integração com Outros MDs

- **MD-002 (Auth Core)**: login único.
- **MD-003 (Operational Context)**: contexto cliente.
- **MD-005 (Event Store)**: eventos CX.
- **MD-010 (Security Core)**: security cliente.
- **MD-014 / MD-019 (App Registry)**: apps CX.
- **MD-020 (Portal Core)**: portal cliente.
- **MD-027 (AI Orchestration Platform)**: IA CX.
- **MD-028 (Enterprise Social Network)**: comunidade cliente.
- **MD-034 (IAM)**: permissões cliente.
- **MD-035 (Security Trust Architecture)**: security cliente.
- **MD-036 (Mobile PWA Architecture)**: mobile CX.
- **MD-039 (Analytics Data Intelligence)**: métricas CX.

---

## Próximo MD recomendado

```text
MD-038 — Integration Hub
```

Hub de integrações.

---

## Regras Canônicas

1. CX é jornada completa.
2. Portal é cliente.
3. CRM é parte de CX.
4. SAC é parte de CX.
5. Portal é parte de CX.
6. Jornada é personalizada.
7. Personalização é IA.
8. CX é omnichannel.
9. CX é contínua.
10. Feedback é obrigatório.
11. NPS é métrica.
12. Satisfação é KPI.
13. CX tem journey orchestrator.
14. CX tem unified profile.
15. CX integra com Social.
16. CX integra com Analytics.
17. CX integra com Security.
18. CX integra com IA.
19. CX integra com Mobile.
20. CX é advocacy.
