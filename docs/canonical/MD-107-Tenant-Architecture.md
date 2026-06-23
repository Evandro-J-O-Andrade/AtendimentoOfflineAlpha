# MD-107 — Tenant Architecture

## Status

Documento Canônico de Multi-Tenancy.
Define a arquitetura de isolamento e governança por tenant.

---

## Objetivo

Garantir que cada tenant (cliente SaaS) oper isolado, seguro e soberano dentro da plataforma.

---

## Princípio Fundamental

```text
Um tenant não vê dados de outro tenant.
Um tenant não acessa funcionalidades de outro tenant.
Um tenant não altera configurações de outro tenant.
Multi-tenant é transversal, não opcional.
```

---

## Modelo de Tenant

```json
{
  "id_tenant": 0,
  "nome": "string",
  "codigo": "string",
  "cnpj": "string",
  "email_contato": "string",
  "plano": "FREE|PRO|BUSINESS|ENTERPRISE",
  "status": "ATIVO|SUSPENSO|CANCELADO|TRIAL",
  "data_inicio": "datetime",
  "data_fim": "datetime|null",
  "limites": {
    "usuarios": 0,
    "armazenamento_gb": 0,
    "api_calls_mes": 0,
    "tokens_ia_mes": 0,
    "apps_ativas": 0
  },
  "configuracoes": {
    "idioma": "pt-BR",
    "moeda": "BRL",
    "fuso_horario": "America/Sao_Paulo",
    "mascara_cpf": true,
    "mascara_cartao": true,
    "retencao_dias": 3650,
    "compliance": ["LGPD", "SOC2"]
  },
  "white_label": {
    "habilitado": false,
    "logo_url": "string|null",
    "nome_marca": "string|null",
    "dominio": "string|null",
    "tema": {}
  },
  "criado_em": "datetime",
  "atualizado_em": "datetime"
}
```

---

## Isolamento por Tenant

### Dados

```text
Toda tabela canônica possui id_tenant.
Toda query canônica filtra por id_tenant.
Nenhuma query cruza dados de tenants distintos.
Soft delete marca tenant como inativo, não deleta dados.
```

### Identidade

```text
Usuários pertencem a tenants.
Perfis pertencem a tenants (ou são globais com escopo por tenant).
Permissões são avaliadas por tenant + app + ação.
Sessões são isoladas por tenant.
```

### Contexto

```text
Unidades pertencem a tenants.
Locais pertencem a tenants.
Configurações são por tenant.
Billing é por tenant.
Eventos são por tenant.
```

### Aplicações

```text
Apps são registradas globalmente.
Ativação de app é por tenant.
Permissão de app é por tenant.
Configuração de app é por tenant.
Uso de app é por tenant.
```

### IA

```text
Modelos são compartilhados (opcional).
Dados de treino são isolados por tenant.
Prompts customizados são por tenant.
Uso de tokens é medido por tenant.
Agentes são isolados por tenant.
```

---

## Camadas de Tenant

### Tenant Root

```text
Entidade máxima de isolamento.
Contrato: plano, limites, status, configurações globais.
Responsável pelo pagamento e compliance.
Pode ter múltiplas unidades.
```

### Unidade

```text
Subdivisão física ou lógica do tenant.
Ex: Filial, Hospital, Clínica, Loja.
Pertence a exatamente um tenant.
Pode ter múltiplos locais.
```

### Local

```text
Subdivisão operacional da unidade.
Ex: Setor, Sala, Guichê, Painel, PDV.
Pertence a exatamente uma unidade.
Pertence a exatamente um tenant (via unidade).
É o nível mais granular de contexto.
```

---

## Ciclo de Vida do Tenant

```
Trials
  ↓
Ativação
  ↓
Período Ativo
  ├── Uso normal
  ├── Upgrade de plano
  ├── Adição de usuários
  ├── Adição de apps
  └── Configurações
  ↓
Suspensão (falta de pagamento, violation)
  ↓
Reativação (pagamento, regularização)
  ↓
Cancelamento voluntário
  ↓
Exclusão (após período de retenção legal)
```

---

## Planos de Tenant

| Plano | Limites | Suporte | SLA |
|-------|---------|---------|-----|
| Free | 5 usuários, 1 GB, apps básicas | Community | Best effort |
| Pro | 50 usuários, 10 GB, apps padrão | Email | 99.0% |
| Business | 500 usuários, 100 GB, apps avançadas | Prioritário | 99.5% |
| Enterprise | Ilimitado*, customizado, todas apps | Dedicado | 99.9% |

*Com limites negociados por contrato.

---

## Políticas por Tenant

### Compliance

```text
Tenant seleciona regulatórios aplicáveis.
LGPD (Brasil)
GDPR (Europa)
HIPAA (EUA saúde)
SOX (EUA financeiro)
PCI-DSS (pagamentos)
ISO 27001
SOC 2
```

### Retenção de Dados

```text
Tenant define período de retenção (conforme legislação).
Plataforma respeita retenção por tenant.
Exclusão após retenção é automática ou manual.
Backup retido por período legal independente de exclusão.
```

### Backup

```text
Backup é por tenant.
Restore é por tenant.
RPO e RTO variam por plano.
Backup é criptografado por tenant.
```

---

## Integrações

```text
MD-017 — Multi-Tenant
MD-034 — Identity Access Management
MD-038 — Integration Hub
MD-058 — Multi-Tenant Billing Engine
MD-059 — SaaS Monetization Platform
MD-077 — Subscription Management
MD-078 — Revenue Operations
MD-096 — Internationalization Platform
MD-097 — Compliance Automation
```

---

## Regras

1. Todo dado carrega `id_tenant`.
2. Nenhuma operação cruza tenants sem autorização explícita.
3. Deleção de tenant é processo, não DELETE direto.
4. Tenant suspenso não acessa a plataforma (read-only para admin).
5. Tenant trial tem limites rígidos e data de expiração.
6. Upgrade/downgrade é efetivado imediatamente, sem downtime.
7. Configurações de tenant não afetam outros tenants.
8. Billing é 100% por tenant.

---

## Lei

```text
Tenant é ilha soberana.
Plataforma é o oceano.
Ilhas não se misturam.
Todas pertencem ao mesmo oceano.
```

---

## Responsabilidades

Plataforma é responsável por:

```text
Isolamento técnico (dados, auth, contexto)
Ciclo de vida de tenant
Planos e limites
Billing e assinatura
Compliance por tenant
Backup e restore por tenant
```

Tenants são responsáveis por:

```text
Manter pagamento em dia
Gerenciar usuários internos
Respeitar limites de plano
Cooperar com auditorias
Reportar incidentes de segurança
```

---

## Métricas

```text
Tenants ativos
Tenants por plano
Tenants por indústria
Taxa de churn
Taxa de upgrade
Taxa de trial conversion
Tempo de setup de novo tenant
Incidentes de cross-tenant (zero tolerância)
Uptime por tenant
Satisfação por tenant (NPS)
```
