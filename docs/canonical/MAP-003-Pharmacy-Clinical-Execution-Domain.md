# MAP-003 — Pharmacy & Clinical Execution Domain

## Status
CANÔNICO
DOMÍNIO ASSISTENCIAL CRÍTICO
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de execução clínica farmacêutica do FCA/Midas.

Controla: Prescrição médica, Validação farmacêutica, Dispensação, Administração, Controle de estoque clínico, Segurança medicamentosa.

---

# 2. Lei Fundamental

```text
Nenhum medicamento é executado sem rastreabilidade completa por evento.
```

---

# 3. Fluxo Macro

```text
Prescrição → Validação → Separação → Dispensação → Administração → Registro
```

---

# 4. Entidades Centrais

```text
Prescricao
Medicamento
Lote
Dispensacao
Administracao
EstoqueClinico
```

---

# 5. Eventos Gerados

```text
PRESCRIPTION_CREATED
PRESCRIPTION_APPROVED
PRESCRIPTION_REJECTED
PRESCRIPTION_ADJUSTED
MEDICATION_DISPENSED
MEDICATION_ADMINISTERED
STOCK_DECREASED
STOCK_ADJUSTED
MEDICATION_CORRECTED
MEDICATION_CANCELLED
```

---

# 6. Regras Macro

- Nenhuma administração sem prescrição válida
- Dose fora de limite gera alerta
- Medicamento controlado requer validação dupla
- Estoque é atualizado automaticamente por evento

---

# 7. Integrações

```text
MAP-002 HIS (Prescrição origem)
MAP-006 Inventory (Estoque destino)
MD-136 Event Driven (Eventos)
MD-132 Communication Center (Alertas/TTS)
```