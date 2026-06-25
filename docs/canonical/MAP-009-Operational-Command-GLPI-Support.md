# MAP-009 — Operational Command & Support Domain

## Status
CANÔNICO
DOMÍNIO OPERACIONAL
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de suporte operacional e manutenção.

Controla: Chamados, incidentes, equipamentos, operação, infraestrutura.

---

# 2. Lei Fundamental

```text
Todo incidente operacional gera evento. Operação é ativo da plataforma.
```

---

# 3. Fluxo Macro

```text
Incidente → Registro → Triagem → Atribuicao → Resolucao → Fechamento
```

---

# 4. Entidades Centrais

```text
Chamado
Incidente
Equipamento
Operacao
CategoriaSuporte
SLA
Prioridade
Tecnico
```

---

# 5. Eventos Gerados

```text
INCIDENT_REPORTED
TICKET_CREATED
ASSIGNMENT_MADE
SLA_BREACHED
RESOLVED
CLOSED
EQUIPMENT_MAINTENANCE_SCHEDULED
```

---

# 6. Regras Macro

- Ticket tem SLA vinculado
- Prioridade é baseada em impacto
- Equipamento possui histórico de falhas
- Solução é documentada automaticamente

---

# 7. Integrações

```text
MAP-007 Inventory (Equipamentos)
MAP-008 Workforce (Técnicos)
MD-136 Event Driven (Eventos)
MD-132 Communication Center (Alertas)
```