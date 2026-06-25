# MAP-004 — Diagnostic & Exams Domain

## Status
CANÔNICO
DOMÍNIO ASSISTENCIAL
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de diagnóstico e exames do FCA/Midas.

Controla: RX, ECG, Laboratório, Imagem, Coleta, Laudos, Equipamentos.

---

# 2. Lei Fundamental

```text
Todo exame possui solicitação, execução e laudo como evento único.
```

---

# 3. Fluxo Macro

```text
Solicitacao → Agendamento → Coleta → Execucao → Resultado → Laudo → Disponibilizacao
```

---

# 4. Entidades Centrais

```text
Exame
SolicitacaoExame
Amostra
Resultado
Laudo
Equipamento
AtividadeExame
```

---

# 5. Eventos Gerados

```text
EXAM_REQUESTED
EXAM_SCHEDULED
SAMPLE_COLLECTED
EXAM_PERFORMED
RESULT_READY
REPORT_GENERATED
EXAM_CANCELLED
```

---

# 6. Regras Macro

- Exame é solicitado por atendimento ativo
- Amostra tem identificador único rastreável
- Resultado segue workflow de validação
- Equipamento possui status operacional

---

# 7. Integrações

```text
MAP-002 HIS (Solicitacao origem)
MAP-005 Scheduling (Agendamento)
MAP-006 Workforce (Técnico executante)
MD-136 Event Driven (Eventos)
MD-125 Display (Exames prontos)
```