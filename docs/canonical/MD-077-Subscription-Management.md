# MD-077 — Subscription Management

## Status

Documento Canônico Complementar Da Arquitetura Da Plataforma Enterprise.

---

## Objetivo

Gerenciar assinaturas SaaS, licenciamento e consumo de toda a plataforma.

---

## Princípio Fundamental

```text
Cada tenant tem um ciclo de vida.

Assinatura define acesso.

Consumo define custo.

Plataforma governa tudo.
```

---

## Recursos

```text
Planos
Licenças
Apps Contratadas
Usuários
Consumo
Faturas
Renovação
Upgrade
Downgrade
Cancelamento
Suspensão
Reativação
```

---

## Planos

```text
Free
Pro
Business
Enterprise
Custom
```

---

## Multi-Tenant

```text
Tenant Free
  ├── Acesso limitado
  ├── Apps públicas
  └── Suporte community

Tenant Pro
  ├── Apps padrão
  ├── Usuários limitados
  └── Suporte padrão

Tenant Business
  ├── Apps avançadas
  ├── Usuários ilimitados
  ├── Integrações
  └── Suporte prioritário

Tenant Enterprise
  ├── Todas as apps
  ├── Multi-unidade
  ├── Customizações
  ├── SLA dedicado
  └── Gerente de conta
```

---

## Componentes

### Plano

```text
Nome
Preço
Recursos inclusos
Limites
Apps permitidas
Suporte
SLA
```

### Licença

```text
Por usuário
Por app
Por feature
Por consumo (tokens IA, storage, API)
```

### Ciclo de Vida

```text
Trials
Ativação
Período ativo
Renovação
Upgrade
Downgrade
Suspensão por falta de pagamento
Cancelamento
Exclusão
```

### Métricas de Consumo

```text
Tokens IA
API calls
Storage
Usuários simultâneos
Jobs N8N
Tempo de execução (Runtime)
Dados processados
```

---

## Integrações

```text
MD-017 Multi-Tenant
MD-058 Multi-Tenant Billing Engine
MD-059 SaaS Monetization Platform
MD-071 Customer 360
MD-072 CRM Enterprise
MD-074 Digital Commerce
MD-078 Revenue Operations
MD-034 IAM
MD-025 Event Store
MD-081 AI Copilot
```

---

## Regras

1. Nenhuma app é acessada sem assinatura válida.
2. Limite de consumo gera bloqueio automático.
3. Upgrade e downgrade são efetivados imediatamente.
4. Faturamento é centralizado no Billing Engine.
5. Eventos de assinatura são emitidos para o Event Store.
6. Cancelamento preserve dados por 90 dias.

---

## Lei

```text
Assinatura não é só pagamento.

Assinatura é o contrato vivo

entre tenant e plataforma.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Catálogo de planos
Controle de licenças
Governança de acesso
Ciclo de vida de tenant
Consumo centralizado
```

Tenants são responsáveis por:

```text
Manter pagamento em dia
Respeitar limites de plano
Gerenciar usuários internos
Configurar integrações contratadas
```

---

## Métricas

```text
MRR
ARR
Churn
LTV
CAC
Expansion MRR
Downgrade rate
Trial conversion
ARPU
Net Revenue Retention
```
