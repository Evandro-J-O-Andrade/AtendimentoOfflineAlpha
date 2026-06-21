# MD-031 — Marketplace & Ecosystem

## Status

Documento Canônico da Plataforma Marketplace da Plataforma Enterprise.

---

## Objetivo

Transformar o sistema em uma plataforma SaaS extensível.

Permitir que terceiros publiquem dentro do ecossistema.

---

## Lei Fundamental

```text
Portal não é apenas software.

Portal é uma plataforma.

Toda extensão pertence ao Marketplace.
```

---

## Arquitetura do Ecossistema

```text
Portal Core
├── App Registry
├── Marketplace
│   ├── Apps
│   ├── Integrações
│   ├── Automações
│   ├── Dashboards
│   ├── Agentes IA
│   └── Templates
└── Ecosystem
    ├── Publishers
    ├── Subscribers
    └── Versions
```

---

## O que pode ser publicado

### Apps

```text
Aplicativos
Módulos
Extensões
Plugins
```

### Integrações

```text
APIs
Webhooks
Conectores
Adapters
```

### Automações

```text
Workflows N8N
Automations
Processos
```

### Dashboards

```text
Templates
Custom views
Reports
```

### Agentes IA

```text
Agentes
Prompts
Modelos
```

### Templates

```text
Documentos
Processos
SPs
```

---

## Publishers

Quem publica:

```text
Admin da Plataforma
Parceiros Certificados
Desenvolvedores Autorizados
Tenants Avançados
```

### Credenciais

```text
API Key
Publish Token
Signature
Webhook Secret
```

---

## Subscribers

Quem consome:

```text
Tenants
Usuários
Apps
Sistemas
```

### Modelo de Assinatura

```json
{
  "subscription_uuid": "UUID",
  "tenant_id": 0,
  "publisher_id": "UUID",
  "item_type": "APP",
  "item_id": "UUID",
  "status": "ACTIVE",
  "expires_at": "datetime",
  "created_at": "datetime"
}
```

---

## Versionamento

Todo item publicado tem versão:

```text
v1.0.0
v1.1.0
v2.0.0
beta
rc
stable
deprecated
```

### SemVer Canônico

1. Major: Breaking changes
2. Minor: Nova funcionalidade
3. Patch: Bug fix

---

## Apps Registradas

```text
MARKETPLACE
ECOSYSTEM
PUBLISHER_PORTAL
SUBSCRIBER_PORTAL
VERSIONS_MANAGER
CATALOG_MANAGER
```

---

## Catalog Manager

Central de catálogo:

```text
Search
Filter
Categories
Ratings
Reviews
Tags
```

### Categorias

```text
UTILIDADES
PRODUTIVIDADE
INTEGRACOES
IA
AUTOMACAO
COLABORACAO
FINANCEIRO
RH
MEDICO
OPERACIONAL
SAUDE
```

---

## Risk & Compliance

### Aprovação obrigatória

```text
Security scan
Code review
Compliance check
Performance test
```

### Certificação

```text
PLATINUM
GOLD
SILVER
BRONZE
```

---

## Monetização

### Modelos

```text
Free
Freemium
Paid
Subscription
Usage-based
```

### Pagamento

```text
Tenant pays
User pays
Partner shares
Platform fee
```

---

## Eventos Canônicos

Todos os eventos do Marketplace vão para Event Store.

### Eventos de Publicação

```text
ITEM_PUBLICADO
ITEM_ATUALIZADO
ITEM_REMOVIDO
ITEM_APROVADO
ITEM_REJEITADO
```

### Eventos de Assinatura

```text
SUBSCRICAO_CRIADA
SUBSCRICAO_ATIVADA
SUBSCRICAO_CANCELADA
SUBSCRICAO_EXPIRADA
```

### Eventos de Uso

```text
ITEM_INSTALADO
ITEM_DESINSTALADO
ITEM_USADO
USAGE_METRICS
```

---

## Segurança

Herda:

```text
JWT
HttpOnly
Refresh Token
MFA
Google Authenticator
Audit Trail
Tenant Isolation
Zero Trust
Webhook Signing
```

### Regras de Segurança

1. Item publicado precisa aprovação.
2. Item é isolado por tenant.
3. Item respeita permissões.
4. Item é auditável.
5. Item tem versionamento.
6. Item tem rollback.
7. Item respeita sandbox.
8. Item não acessa diretamente.
9. Item usa Dispatcher.
10. Item gera eventos.

---

## Integração com Outros MDs

- **MD-002 (Auth)**: identidade e permissões para publishers/subscribers.
- **MD-004 (Dispatcher)**: execução de ações publicadas.
- **MD-005 (Event Store)**: eventos do marketplace.
- **MD-014 / MD-019 (App Registry)**: registro de apps publicados.
- **MD-016 (Auditoria)**: rastreabilidade.
- **MD-017 (MultiTenant)**: isolamento.
- **MD-020 (Portal Core Architecture)**: Portal como origem.
- **MD-025 (Event Store Core)**: eventos imutáveis.
- **MD-026 (Security Zero Trust)**: segurança.
- **MD-027 (AI Orchestration Platform)**: agentes IA publicados.
- **MD-034 (Identity Access Management)**: permissões de marketplace.

---

## Próximo MD recomendado

```text
MD-032 — Unified Communication & Engagement Platform
```

Hub de comunicação unificada.

---

## Regras Canônicas

1. Marketplace é a extensibilidade da plataforma.
2. Portal Core é a origem.
3. Todo item publicado precisa registro.
4. Todo item publicado precisa aprovação.
5. Todo item respeita tenant isolation.
6. Todo item respeita Zero Trust.
7. Todo item gera evento.
8. Todo item é auditável.
9. Todo item tem versão.
10. Todo item tem rollback.
11. Publishers precisam credenciais.
12. Subscribers precisam permissão.
13. Monetização é opcional.
14. Certificação é obrigatória para parceiros.
15. Marketplace integra com IA.
16. Marketplace integra com N8N.
17. Marketplace integra com Analytics.
18. Marketplace integra com Portal.
19. Marketplace é o modelo de expansão.
20. Marketplace transforma software em plataforma.