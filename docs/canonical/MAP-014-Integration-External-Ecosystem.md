# MAP-014 — Integration & External Ecosystem

## Status
CANÔNICO
DOMÍNIO DE INTEGRAÇÃO
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de integração e ecossistema externo.

Controla: APIs externas, equipamentos, laboratórios externos, governo, N8N.

---

# 2. Lei Fundamental

```text
Integração é sempre via API oficial. Dado externo passa por validação.
```

---

# 3. Fluxo Macro

```text
Solicitacao → API Gateway → Destino → Retorno → Evento
```

---

# 4. Entidades Centrais

```text
Integracao
API
EquipamentoExterno
LaboratorioExterno
Governo
Webhook
JobExterno
```

---

# 5. Eventos Gerados

```text
EXTERNAL_REQUEST_SENT
EXTERNAL_DATA_RECEIVED
INTEGRATION_ERROR
JOB_COMPLETED
WEBHOOK_TRIGGERED
SYNC_COMPLETED
```

---

# 6. Regras Macro

- Integração não bypassa regras internas
- Dado externo é validado antes do consumo
- Webhook tem retries configuráveis
- Job possui timeout

---

# 7. Integrações

```text
MD-038 Integration Hub
MAP-004 Diagnostic (Exames externos)
MAP-007 Inventory (Fornecedores)
MD-136 Event Driven (Eventos)
```