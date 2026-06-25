# MAP-008 — Workforce & HR Operational Domain

## Status
CANÔNICO
DOMÍNIO OPERACIONAL
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de recursos humanos operacionais.

Controla: Escala, plantão, equipes, alocação, profissionais.

---

# 2. Lei Fundamental

```text
Profissional é Pessoa com papel operacional. Escala é recurso limitado.
```

---

# 3. Fluxo Macro

```text
Profissional → Alocacao → Escala → Plantao → Registro de Atividade
```

---

# 4. Entidades Centrais

```text
Profissional
Escala
Plantao
Alocacao
Equipe
Competencia
RegraTrabalho
```

---

# 5. Eventos Gerados

```text
PROFESSIONAL_ASSIGNED
SHIFT_STARTED
SHIFT_ENDED
TEAM_ALLOCATED
WORK_RULE_VIOLATED
OVERTIME_RECORDED
```

---

# 6. Regras Macro

- Profissional possui competências
- Escala não pode ter sobreposição sem autorização
- Plantão gera carga horária automática
- Equipe é agrupamento de profissionais

---

# 7. Integrações

```text
MAP-002 HIS (Profissional executante)
MAP-004 Diagnostic (Técnicos)
MAP-005 Scheduling (Agendamento profissional)
MD-034 IAM (Pessoas/Papéis)
MD-136 Event Driven (Eventos)
```