# MD-INDEX — DOMÍNIO MAPPING

## TABELAS → MD CORRESPONDENTE

| Table Group | MD Number | Status | Observação |
|-------------|-----------|--------|----------|
| senha, senha_eventos | MD-002 | 🟢 SYNCED | Queue Engine |
| ffa, ffa_*, atendimento_evento | MD-003 | 🟢 SYNCED | Core Workflow |
| usuario, sessao_usuario, perfil | MD-001 | 🟢 SYNCED | Identity |
| farm_dispensacao, estoque_* | MD-005 | 🟢 SYNCED | Pharmacy |
| painel, tv_rotativo, totem | MD-125 | 🟡 CHECK | Display |
| faturamento_*, gpat | MD-117 | 🟡 CHECK | Billing |
| internacao_*, leito | MD-117 | 🟡 CHECK | Inpatient |
| agenda_* | MD-XXX | 🔴 MISSING | Agendamento |
| chamado_* | MD-XXX | 🔴 MISSING | SAC |
| regulacao_* | MD-XXX | 🔴 MISSING | Regulação |

---

*TOTAL: 478 tabelas mapeadas para 8 domínios*
*MISSING: 3 domínios sem MD (agendamento, SAC, regulação)*