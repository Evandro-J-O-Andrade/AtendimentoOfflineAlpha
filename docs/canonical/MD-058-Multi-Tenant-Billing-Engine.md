# MD-058 — Multi-Tenant Billing Engine

## Status

Documento Canônico do Motor de Cobrança Multi-Tenant da Plataforma Enterprise.

---

## Objetivo

Gerenciar toda a monetização da plataforma SaaS.

Assinaturas, consumo, licenças, marketplace.

Cobrança justa, transparente, automatizada.

---

## Princípio Fundamental

```text
Cada tenant paga pelo que consome.

Cada app gera sua receita.

Cada IA cobra seu custo.

Plataforma monetiza o ecossistema.
```

---

## Billing Architecture

```text
Usage Collector
    ↓
Metering Engine
    ↓
Rating Engine
    ↓
Billing Engine
    ↓
Invoice Generator
    ↓
Payment Gateway
    ↓
Revenue Recognition
    ↓
Accounting
```

---

## Billing Models

### Subscription

```text
Plano Básico: usuários limitados, apps básicas
Plano Profissional: usuários ilimitados, apps premium
Plano Enterprise: customizado, suporte dedicado
Plano White Label: marca própria, infra dedicada
```

### Pay-per-Use

```text
Por API call
Por execução de SP
Por armazenamento
Por banda
Por usuário ativo (MAU)
Por execução de IA (tokens)
Por workflow N8N
Por storage
Por transferência
```

### Hybrid

```text
Base subscription + overage
Base subscription + usage add-ons
Tiered pricing
Volume discounts
Commitment discounts
Early payment discounts
```

### Freemium

```text
Free tier: limitado, para trial
Conversion funnel
Usage limits por feature
Time limits
Nurture para upgrade
```

---

## Metering

### What is Metered

```text
API calls
SP executions
Storage consumed
Bandwidth consumed
Active users (DAU/MAU)
IA tokens (input + output)
N8N workflow executions
Messages sent (Communication Hub)
Records stored (Data Lake)
Compute minutes
Runtime sync operations
Agent executions
Integration calls
```

### Metering Granularity

```text
REALTIME: billing events imediatos
HOURLY: agregados por hora
DAILY: agregados por dia
MONTHLY: fechamento mensal
```

### Metering Model

```json
{
  "meter_uuid": "UUID",
  "tenant_id": 0,
  "metric": "API_CALL|STORAGE_GB|IA_TOKEN|MAU|WORKFLOW",
  "quantity": 0,
  "unit": "CALL|GB|TOKEN|USER|EXECUTION",
  "price_per_unit": 0.0,
  "app_id": "string",
  "dominio": "string",
  "period_start": "datetime",
  "period_end": "datetime",
  "created_at": "datetime"
}
```

---

## Rating & Pricing

### Rating Engine

```text
Consome meters
Aplica preços
Aplica regras de negócio
Aplica descontos
Aplica tiers
Gera charges
```

### Pricing Rules

```text
Base price per metric
Volume tiers (maior volume = menor preço)
Tenant tier (plan-based pricing)
Promotional pricing
Contract pricing
Custom pricing
Regional pricing
```

### Charge Model

```json
{
  "charge_uuid": "UUID",
  "tenant_id": 0,
  "invoice_id": "UUID",
  "metric": "API_CALL",
  "quantity": 1000,
  "unit_price": 0.001,
  "subtotal": 1.0,
  "discount": 0.1,
  "tax": 0.0,
  "total": 0.9,
  "period": "2026-06",
  "status": "PENDING|BILLED|PAID|OVERDUE|CANCELLED"
}
```

---

## Invoicing

### Invoice Types

```text
Subscription invoice (recorrente mensal)
Usage invoice (consumo variável)
One-time invoice (setup, onboarding)
Credit note (estornos, ajustes)
Proforma invoice
```

### Invoice Content

```text
Company info (emitente)
Client info (tenant)
Period covered
Line items por métrica
Subtotals por app/domínio
Discounts aplicados
Taxes (ISS, ICMS, PIS, COFINS)
Total due
Payment terms
Due date
Payment methods
```

---

## Payment

### Gateways

```text
Stripe
Mercado Pago
PagSeguro
Adyen
PayPal
Boleto
PIX
Transferência
Cartão de crédito/débito
```

### Payment Flow

```text
Invoice generated
    ↓
Notify tenant
    ↓
Payment attempt
    ↓
Success → Bill paid
Failure → Retry
    ↓
Overdue → Dunning
    ↓
Suspension → if critical overdue
```

### Dunning

```text
Day 0: Invoice due
Day +3: First reminder
Day +7: Second reminder
Day +14: Third reminder + service impact notice
Day +30: Service reduction
Day +45: Service suspension
Day +60: Account termination
```

---

## Revenue Recognition

### Recognition Rules

```text
Subscription: monthly recognition
Usage: upon billing or consumption
One-time: upon delivery
Subscription with setup: setup recognized immediately, subscription over term
Annual contracts: monthly recognition
```

### Revenue by Source

```text
Platform subscriptions
App subscriptions
IA usage
N8N workflow executions
Marketplace commissions
Integration fees
Support plans
Training & certification
Consulting services
White label licensing
```

---

## Marketplace Billing

### Marketplace Economics

```text
Platform fee (comissão sobre transação)
App subscription (parceiro define preço)
Revenue share (padrão: 70/30)
Payment processing fee
Payout to partners
Payout schedule (monthly net-30)
```

### Marketplace Model

```json
{
  "marketplace_transaction": {
    "transaction_uuid": "UUID",
    "buyer_tenant_id": 0,
    "seller_partner_id": "UUID",
    "app_id": "string",
    "amount": 100.0,
    "platform_fee": 30.0,
    "seller_payout": 70.0,
    "payment_fee": 3.0,
    "status": "PENDING|PAID|DISPUTED|REFUNDED",
    "period": "2026-06",
    "payout_date": "datetime"
  }
}
```

---

## Cost Tracking

### IA Costs

```text
Tokens input
Tokens output
Model pricing per token
Tenant/App/Agent attribution
Monthly aggregation
Cost alerts
```

### Infrastructure Costs

```text
Compute
Storage
Network
Managed services
Attribution por tenant
Attribution por app
```

---

## Integration with Other MDs

- **MD-002 (Auth)**: identidade para billing.
- **MD-003 (Operational Context)**: contexto de uso.
- **MD-004 (Dispatcher)**: ações billable.
- **MD-005 (Event Store)**: eventos de uso.
- **MD-010 (Security)**: security de billing.
- **MD-014 / MD-019 (App Registry)**: apps com pricing.
- **MD-016 (Auditoria)**: auditoria financeira.
- **MD-017 (MultiTenant)**: billing por tenant.
- **MD-031 (Marketplace)**: marketplace billing.
- **MD-034 (IAM)**: permissões de billing.
- **MD-035 (Security Trust Architecture)**: security.
- **MD-038 (Integration Hub)**: payment integrations.
- **MD-039 (Analytics Data Intelligence)**: revenue analytics.
- **MD-052 (AI Data Fabric)**: custo de IA.

---

## Próximo MD recomendado

```text
MD-059 — SaaS Monetization Platform
```

Monetização da plataforma.

---

## Regras Canônicas

1. Billing é por tenant.
2. Usage é medido com precisão.
3. Pricing é transparente.
4. Invoice é detalhada.
5. Payment é automatizado.
6. Dunning é estruturado.
7. Revenue recognition é compliant.
8. Marketplace tem revenue share.
9. IA custo é tracked.
10. Cost alerts existem.
11. Billing respeita Multi-Tenant.
12. Billing é auditável.
13. Dunning é humano-assisted.
14. Suspensão é último recurso.
15. Billing integra com ERP.
16. Billing integra com Financeiro.
17. Billing alimenta Analytics.
18. Refund é rastreável.
19. Pricing é versionado.
20. Billing é confiança financeira.

---

## Proibições

São proibidos:

```text
Billing cross-tenant
Cobrança sem auditoria
Invoice sem detalhamento
Alteração de preço sem notificação
Dunning sem human approval suspensão
Revenue recognition sem compliance
Marketplace sem revenue share transparente
Custo de IA sem attribution
Payment sem comprovante
Billing sem retenção fiscal
```
