# MAP-012 — CRM Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio comercial.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Comercial
```

## Objetivo
Definir a arquitetura completa do CRM com bounded contexts, agregados, eventos e regras de negócio.
Esta é a fundação do core comercial da plataforma.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → CRM → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-013 — Application Registry é Obrigatório
```text
Toda integração com CRM passa por Registry
```

---

## Lei Canônica MAP-012-001
```text
Todo fluxo comercial começa por Lead. Todo Lead tem origem.
```

---

## Hierarquia de Domínios
```text
CRM Domain
├── Lead Context
├── Opportunity Context
├── Account Context
├── Contact Context
└── Contract Context
```

---

## Fluxo Comercial Oficial
```text
Lead
↓
Contato
↓
Oportunidade
↓
Proposta
↓
Contrato
```

---

## Bounded Contexts

### Lead Context
Responsável por: Lead, Fonte, Status, Score, Histórico
Agregado: Lead

### Opportunity Context
Responsável por: Oportunidade, Valor, Estágio, Probabilidade, Atividades
Agregado: Opportunity

### Account Context
Responsável por: Conta, Cliente, Contratos, Relacionamento
Agregado: Account

### Contact Context
Responsável por: Contato, Telefone, Email, Histórico
Agregado: Contact

---

## Agregados Principais

### Lead Aggregate
```text
lead_id (PK)
tenant_id (FK)
source
status
score
assigned_to (user_id)
nome
telefone
email
criado_em
```

### Opportunity Aggregate
```text
opportunity_id (PK)
account_id (FK)
titulo
valor
estagio
probabilidade
close_date
owner_id (user_id)
criado_em
atualizado_em
```

### Account Aggregate
```text
account_id (PK)
tenant_id (FK)
nome
tipo
cnpj
endereco
dono_id (user_id)
status
criado_em
```

---

## Eventos Oficiais

### LeadCriado
Payload: {lead_id, source, nome, telefone, tenant_id}

### LeadConvertido
Payload: {lead_id, opportunity_id, account_id, timestamp}

### OpportunityCriada
Payload: {opportunity_id, account_id, valor, estagio}

### OpportunityGanha
Payload: {opportunity_id, valor_fechado, close_date}

### OpportunityPerdida
Payload: {opportunity_id, motivo, close_date}

### AccountAtualizada
Payload: {account_id, campo, valor_anterior, valor_novo}

---

## Stored Procedures

### sp_lead_criar
Input: {nome, telefone, email, source, user_id}
Output: {lead_id, numero, created_at}

### sp_lead_converter
Input: {lead_id, user_id}
Output: {opportunity_id, account_id}

### sp_opportunity_criar
Input: {account_id, titulo, valor, estagio, user_id}
Output: {opportunity_id}

### sp_opportunity_atualizar_stage
Input: {opportunity_id, novo_estagio, user_id}
Output: {status, atualizado_em}

---

## APIs Oficiais

### /api/v1/crm/leads
POST - Criar lead
GET - Listar leads

### /api/v1/crm/opportunities
POST - Criar oportunidade
PUT - Atualizar estágio

---

## Regras Arquiteturais

### SP First Rule
Toda operação de escrita no CRM passa por Stored Procedure.

### Audit First Rule
Toda mudança é registrada com user_id e timestamp.

### Multi-Tenant Rule
Toda consulta inclui WHERE tenant_id = ?

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant | Tenant context |
| MAP-003 — Identity | Auth/Authorization |
| MD-072 — CRM Enterprise | CRM patterns |
| FRONT-035 — CRM Experience | UX |
| FRONT-051 — Customer 360 | 360° |