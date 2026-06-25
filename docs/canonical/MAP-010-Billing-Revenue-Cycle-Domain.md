# MAP-010 — Billing & Revenue Cycle Domain

## Status
CANÔNICO
DOMÍNIO FINANCEIRO
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de faturamento e ciclo de receita.

Controla: Contas, procedimentos, convênios, faturamento, recebimento.

---

# 2. Lei Fundamental

```text
Faturamento nasce da execução assistencial. Todo procedimento possui código.
```

---

# 3. Fluxo Macro

```text
Atendimento → Procedimento → Conta → Faturamento → Recebimento
```

---

# 4. Entidades Centrais

```text
Conta
Procedimento
Faturamento
Recebimento
Convenio
Guia
Autorizacao
Desconto
```

---

# 5. Eventos Gerados

```text
BILLING_GENERATED
PROCEDURE_BILLED
INVOICE_CREATED
PAYMENT_RECEIVED
CONVENIO_AUTHORIZED
CLAIM_SUBMITTED
```

---

# 6. Regras Macro

- Conta é originária do atendimento
- Procedimento tem tabela oficial
- Convênio valida autorização
- Recebimento é evento contábil

---

# 7. Integrações

```text
MAP-002 HIS (Procedimentos)
MAP-003 Pharmacy (Medicamentos)
MD-101 Canonical Data (Tabelas contábeis)
MD-136 Event Driven (Eventos)
```