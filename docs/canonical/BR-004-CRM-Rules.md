# BR-004 — CRM Rules

## Status
Documento Canônico de Regras de Negócio.

---

## Regras

```text
REGRA-004-01: Lead não pode existir sem tenant
REGRA-004-02: Lead com nome e contato obrigatórios
REGRA-004-03: Lead atribuído automaticamente
REGRA-004-04: Conversão = transição para Opportunity
REGRA-004-05: Opportunity não pode existir sem Account
REGRA-004-06: Stage segue pipeline obrigatório
REGRA-004-07: Valor total atualizado por children
REGRA-004-08: Contrato não pode existir sem Account
```

---

## Stored Procedures

### sp_lead_converter
### sp_opportunity_update_stage
### sp_contract_create