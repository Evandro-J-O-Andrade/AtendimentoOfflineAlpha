# MAP-006 — Care Continuity / Patient Journey

## Status
CANÔNICO
DOMÍNIO ASSISTENCIAL
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de continuidade assistencial e jornada do paciente.

Controla: Histórico longitudinal, follow-up, evolução, encaminhamentos, programas crônicos.

---

# 2. Lei Fundamental

```text
Jornada do paciente transcende episódios. Eventos conectam histórias.
```

---

# 3. Fluxo Macro

```text
Episodio → Encerramento → Follow-up → Nova Jornada → Evolucao Continua
```

---

# 4. Entidades Centrais

```text
JornadaPaciente
Evolucao
Encaminhamento
Referencia
ContraReferencia
Programa
CarePlan
```

---

# 5. Eventos Gerados

```text
JOURNEY_STARTED
EPISODE_COMPLETED
FOLLOWUP_SCHEDULED
REFERRAL_CREATED
PROGRAM_ENROLLED
CARE_PLAN_UPDATED
OUTCOME_RECORDED
```

---

# 6. Regras Macro

- Jornada conecta todos episódios do paciente
- Evolução é série temporal de eventos
- Follow-up é gerado automaticamente
- Programas crônicos têm duração

---

# 7. Integrações

```text
MAP-002 HIS (Episodios)
MAP-005 Scheduling (Follow-up)
MD-136 Event Driven (Eventos)
MD-120 Party Identity (Pessoa/Paciente)
```