# MAP-007 — Inventory & Supply Chain Domain

## Status
CANÔNICO
DOMÍNIO OPERACIONAL
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de estoque e cadeia de suprimentos.

Controla: Medicamentos, materiais, insumos, requisições, almoxarifado, consumo.

---

# 2. Lei Fundamental

```text
Estoque é recurso limitado. Todo movimento gera evento de rastreabilidade.
```

---

# 3. Fluxo Macro

```text
Requisicao → Aprovacao → Compra → Recebimento → Estoque → Consumo → Registro
```

---

# 4. Entidades Centrais

```text
Produto
Estoque
Requisicao
Compra
Recebimento
Movimento
Lote
Validade
```

---

# 5. Eventos Gerados

```text
PRODUCT_CREATED
STOCK_RECEIVED
STOCK_DECREASED
STOCK_ADJUSTED
REORDER_TRIGGERED
EXPIRY_ALERT
ORDER_PLACED
ORDER_RECEIVED
```

---

# 6. Regras Macro

- Estoque não pode ficar negativo
- Lote com validade expirada gera alerta
- Medicamento controlado requer auditoria adicional
- Reabastecimento automático por SLA

---

# 7. Integrações

```text
MAP-003 Pharmacy (Consumo)
MAP-002 HIS (Medicamentos)
MAP-014 Integration (Fornecedores)
MD-136 Event Driven (Eventos)
MD-132 Communication Center (Alertas)
```