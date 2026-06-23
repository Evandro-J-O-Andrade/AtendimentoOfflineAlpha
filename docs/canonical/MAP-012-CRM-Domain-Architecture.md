# MAP-012 — CRM Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio comercial.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Comercial
```

---

## Objetivo
Definir arquitetura completa do CRM com pipedream e automação.

---

## Bounded Contexts

### Lead Context
```text
Lead
Fonte
Status
Score
Histórico
```

### Opportunity Context
```text
Oportunidade
Valor
Estágio
Probabilidade
Atividades
```

### Account Context
```text
Conta
Cliente
Contratos
Relacionamento
```

### Contact Context
```text
Contato
Telefone
Email
Histórico
```

---

## Agregados

### Lead Aggregate
```text
lead_id
tenant_id
source
status
score
assigned_to
created_at
```

### Opportunity Aggregate
```text
opportunity_id
account_id
value
stage
probability
close_date
created_at
```

---

## Eventos Oficiais

### LeadCriado
### LeadConvertido
### OpportunityCriada
### OpportunityGanha
### OpportunityPerdida
### AccountAtualizada

---

## Stored Procedures

### sp_lead_criar
### sp_lead_converter
### sp_opportunity_criar
### sp_opportunity_atualizar_stage

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-072 — CRM Enterprise | CRM |
| FRONT-035 — CRM Experience | UX |
| FRONT-051 — Customer 360 | 360° |