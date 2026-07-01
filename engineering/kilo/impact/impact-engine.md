# IMPACT ENGINE — KILO v7

## 🎯 CAPACIDADE

Analisar automaticamente o impacto de mudanças em qualquer componente.

---

## EXEMPLO: Impacto da tabela `agendamento`

```
ALTER TABLE agendamento ADD COLUMN novo_campo VARCHAR(50)
```

### Impacto Detectado:

| Layer | Affected Components | Count |
|-------|-------------------|-------|
| Stored Procedures | sp_agenda_*, sp_cliente_* | 12 |
| Backend APIs | GET/POST/PUT /agenda | 6 endpoints |
| Frontend Pages | AgendaPage, AgendaForm | 8 arquivos |
| DTOs | AgendaDTO, AgendaCreateDTO | 4 |
| Controllers | agenda.controller.ts | 2 |
| Tests | agenda.e2e.spec.ts | 1 |
| Documentation | AGENDAMENTO_CANONICO.md | 1 |

---

## EXEMPLO: Impacto de sp_senha_emitir (MISSING → CREATE)

### Impacto Positivo:

| Layer | Components | Action |
|-------|------------|--------|
| MD-105 | Flow compliance | ✅ CONFORME |
| BR-001 | Regra de entrada | ✅ IMPLEMENTA |
| FRONT-002 | Fila real-time | ✅ ATUALIZA |
| API Layer | Novo endpoint | ✨ CRIAR |
| Event System | SenhaEmitida evento | ✨ CRIAR |

---

## IMPACT MATRIX (AUTO-GERADO)

| Component | Tables | SPs | APIs | Fronts | Tests | Docs |
|-----------|--------|-----|------|--------|-------|------|
| AGENDAMENTO | agendamento*, agendamentos_eventos | 0 (MISSING) | 0 | 0 | 0 | 0 |
| SENHA | senha, senha_eventos | 6 existentes, 2 missing | FRONT-002 | AgendaPage | 0 | MD-002, BR-001 |
| FFA | ffa, atendimento_evento | 4 | FRONT-003 | AtendimentoPage | 0 | MD-003, BR-002 |
| FARMACIA | farm_dispensacao, estoque_* | 5 | FRONT-004 | FarmaciaPage | 0 | MD-005, BR-003 |

---

## BACKLOG AUTO-GERADO

```json
{
  "P0_CRITICAL": [
    "sp_senha_emitir implementation",
    "sp_sessao_assert implementation",
    "kernel_ledger migration bridge"
  ],
  "P1_HIGH": [
    "MD-003 canonize sp_gatekeeper",
    "MD-105 flow patch",
    "FRONT-002 API endpoint"
  ],
  "P2_MEDIUM": [
    "Agenda domain creation",
    "MAP-007 Agendamento",
    "BR-014 Agendamento flow"
  ]
}
```