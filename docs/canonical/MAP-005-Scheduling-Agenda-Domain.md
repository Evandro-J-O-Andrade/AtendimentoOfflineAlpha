# MAP-005 — Scheduling & Agenda Domain

## Status
CANÔNICO
DOMÍNIO OPERACIONAL
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de agendamento e agenda do FCA/Midas.

Controla: UBS, consultas, exames, retornos, escalas.

---

# 2. Lei Fundamental

```text
Agenda é capacidade limitada. Agendamento é evento vinculado a atendimento.
```

---

# 3. Fluxo Macro

```text
Disponibilidade → Agendamento → Confirmação → Execução → Conclusão
```

---

# 4. Entidades Centrais

```text
AgendaSlot
Agendamento
Recorrencia
Reminder
Cancelamento
Reagendamento
Resource
```

---

# 5. Eventos Gerados

```text
SLOT_CREATED
APPOINTMENT_SCHEDULED
APPOINTMENT_CONFIRMED
APPOINTMENT_CANCELLED
APPOINTMENT_COMPLETED
RECURRENT_APPOINTMENT_CREATED
REMINDER_SENT
```

---

# 6. Regras Macro

- Slot define capacidade real
- Agendamento não pode conflitar
- Recorrência gera eventos encadeados
- Cancelamento é evento, não delete

---

# 7. Integrações

```text
MAP-002 HIS (Agendamento assistencial)
MAP-004 Diagnostic (Exames)
MAP-008 Workforce (Profissionais)
MD-136 Event Driven (Eventos)
MD-132 Communication Center (Lembretes)
```