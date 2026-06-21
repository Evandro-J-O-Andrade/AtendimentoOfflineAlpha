# MD-030 — Enterprise Analytics & Governance Platform

## Status

Documento Canônico da Camada de Analytics e Governança da Plataforma Enterprise.

---

## Objetivo

Transformar a plataforma em uma organização orientada por dados.

Toda aplicação produz indicadores.

Todo indicador converge para o Portal Analytics.

---

## Lei Fundamental

```text
Se não pode ser medido,
não pode ser gerenciado.

Se não pode ser auditado,
não pode ser governado.
```

---

## Visão Arquitetural

```text
Apps
↓
Event Store
↓
Analytics Engine
↓
Governance Engine
↓
Portal Executive Dashboard
```

---

## Domínios Monitorados

### Portal Core

```text
Usuários ativos
Sessões
Apps utilizadas
Tempo de uso
Engajamento
```

### IA

```text
Tokens
Custos
Modelos
Agentes
Prompts
Latência
```

### N8N

```text
Workflows
Execuções
Falhas
Tempo médio
Consumo
```

### CRM

```text
Leads
Conversões
Funil
Clientes
Receita
```

### SAC

```text
Chamados
SLA
Tempo resposta
NPS
Satisfação
```

### Financeiro

```text
Receita
Despesa
Lucro
Fluxo Caixa
Inadimplência
```

### PDV

```text
Vendas
Ticket Médio
Produtos
Margem
```

### AVA

```text
Cursos
Certificados
Progresso
Conclusão
```

### Rede Social

```text
Postagens
Engajamento
Comunidades
Chats
```

### Operacional

```text
Filas
Atendimentos
Produtividade
Tempo Médio
```

---

## Dashboard Executivo Global

O Portal terá um cockpit executivo.

Semelhante a:

```text
Power BI
Tableau
Looker
Grafana Enterprise
```

Mas integrado nativamente.

---

## Camadas de Dashboard

### Dashboard Global

Visão da plataforma inteira.

### Dashboard Tenant

Visão da empresa.

### Dashboard Unidade

Visão operacional.

### Dashboard App

Visão específica da aplicação.

### Dashboard Usuário

Visão individual.

---

## Governança

Monitora:

```text
Segurança
Auditoria
LGPD
Custos
Uso IA
Integrações
Performance
Compliance
```

### Apps de Governança

```text
RISK_CENTER
COMPLIANCE_CENTER
COST_CENTER
GOVERNANCE_MANAGER
```

---

## Centro de Custos

Muito importante para SaaS.

Controla:

```text
OpenAI
Gemini
Claude
N8N
WhatsApp
SMS
Email
Storage
Infraestrutura
```

Por:

```text
Tenant
App
Usuário
Departamento
```

### Modelo Canônico de Custo

```json
{
  "custo_uuid": "UUID",
  "tenant_id": 0,
  "app": "IA",
  "categoria": "OPENAI_TOKENS",
  "valor_usd": 0,
  "periodo": "MENSAL",
  "fonte": "EVENT_STORE",
  "timestamp": "datetime"
}
```

---

## Risk Center

Monitora:

```text
Logins suspeitos
Tentativas de invasão
Tokens inválidos
Webhooks suspeitos
Fraudes
```

Integrado ao MD-026 Security Zero Trust.

---

## Compliance Center

```text
LGPD
Auditoria
Retenção
Consentimento
Termos
Políticas
```

### Regras de Compliance

1. Todo dado tem dono.
2. Todo dado tem política.
3. Todo dado respeita retenção.
4. Todo dado respeita anonimização.
5. Todo dado é auditável.

---

## Integração com Event Store

Tudo vem dos eventos.

```text
Evento
↓
Analytics
↓
KPI
↓
Dashboard
```

Sem duplicação.

### Lei de Analytics

```text
Analytics não aceita métrica sem origem.

Analytics não aceita dado sem Event Store.

Analytics não duplica dados.
```

---

## Apps Registradas

```text
ANALYTICS
BI
EXECUTIVE_DASHBOARD
RISK_CENTER
COMPLIANCE_CENTER
COST_CENTER
GOVERNANCE_MANAGER
```

---

## Lei Canônica

```text
Nenhuma aplicação possui governança própria.

Toda governança pertence ao Enterprise Analytics & Governance Platform.

Todo indicador estratégico converge para o Portal Core.
```

---

## Eventos Canônicos

Todos os eventos do Analytics vão para Event Store.

### Eventos de Métrica

```text
METRICA_REGISTRADA
KPI_CALCULADO
DASHBOARD_ACESSADO
REPORT_GERADO
ALERTA_DISPARADO
CUSTO_CALCULADO
```

### Eventos de Governança

```text
DADOS_ACEITOS
DADOS_REJEITADOS
POLITICA_APLICADA
RETENCAO_EXECUTADA
ANONIMIZACAO_APLICADA
COMPLIANCE_VIOLADO
```

---

## Integração com Outros MDs

- **MD-002 (Auth)**: identidade, sessão, JWT, refresh token e MFA.
- **MD-003 (Operational Context)**: tenant, unidade, local, perfil e contexto operacional.
- **MD-004 (Dispatcher)**: entrada oficial de ações executáveis.
- **MD-005 (Event Store)**: origem primária de dados para Analytics.
- **MD-010 (Security)**: base de segurança.
- **MD-014 / MD-019 (App Registry)**: todas as apps integram ao Analytics.
- **MD-016 (Auditoria)**: rastreabilidade dos dados.
- **MD-017 (MultiTenant)**: isolamento por tenant.
- **MD-020 (Portal Core Architecture)**: Portal como origem.
- **MD-025 (Event Store Core)**: fonte imutável de eventos.
- **MD-026 (Security Zero Trust)**: integração com Risk Center.
- **MD-027 (AI Orchestration Platform)**: métricas de IA.
- **MD-028 (Enterprise Social Network)**: métricas de Social.
- **MD-029 (Digital Workplace Platform)**: métricas do Workplace.
- **MD-034 (Identity Access Management)**: permissões e perfis.

---

## Regras Canônicas

1. Analytics é visão única da plataforma.
2. Portal Core é origem de todas as apps.
3. Event Store é origem de todas as métricas.
4. Todo app gera métricas canônicas.
5. Todo app gera eventos.
6. Todo evento alimenta Analytics.
7. Analytics respeita tenant isolation.
8. Analytics respeita Zero Trust.
9. Analytics respeita LGPD.
10. Analytics é auditável.
11. Analytics tem owner de dados.
12. Analytics tem políticas de retenção.
13. Analytics anonimiza dados sensíveis.
14. Analytics tem role-based access.
15. Analytics gera alertas.
16. Analytics gera relatórios.
17. Analytics tem dashboards personalizáveis.
18. Analytics integra com IA.
19. Analytics mede custos de IA.
20. Analytics é o cérebro da plataforma.