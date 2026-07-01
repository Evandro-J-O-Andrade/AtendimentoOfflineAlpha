# DATABASE INVENTORY — KILO v7

## SUMMARY

- **Total Tables**: 478
- **Total SPs**: 19
- **Total Views**: 1 (vw_usuario_permissoes - INCONCLUSIVO)
- **Total Functions**: 0 (identificado no dump)
- **Total FKs**: 283
- **Event Tables**: 28+

---

## CORE TABLES

| Table | Type | FK Count | Used By SPs |
|-------|------|----------|-------------|
| saas_entidade | PLATFORM | 0 | HUB |
| usuario | DOMAIN | 3 | HUB |
| sessao_usuario | DOMAIN | 1 | 12 SPs |
| unidade | DOMAIN | 2 | 15 SPs |
| ffa | DOMAIN | 3 | 5 SPs |
| senha | DOMAIN | 3 | 6 SPs |
| gpat | DOMAIN | 2 | 2 SPs |

---

## EVENT TABLES (FRAGMENTED)

| Table | Canonical Target | Status |
|-------|------------------|--------|
| auditoria_evento | kernel_ledger | CANONICAL_USED |
| atendimento_evento | kernel_ledger | LEGACY_USED |
| workflow_ffa_evento | kernel_ledger | LEGACY_USED |
| senha_eventos | kernel_ledger | LEGACY_USED |
| estoque_audit_stream | kernel_ledger | LEGACY_USED |
| rh_evento | kernel_ledger | LEGACY_USED |

---

## MISSING SPs (CRITICAL)

| SP | Reason | Priority |
|-----|--------|----------|
| sp_senha_emitir | MD-105 flow compliance | P0 |
| sp_sessao_assert | Referenced in 8 SPs | P0 |
| sp_kernel_ledger_write | MD-104 event system | P0 |
| sp_checkpoint_global_validar | Called by guardião | P1 |
| sp_codigo_emitir_interno | Called by GPAT | P1 |

---

## DRIFT ANALYSIS

```
sp_master_dispatcher (MD) → sp_gatekeeper_assistencial (real)
kernel_ledger (MD) → auditoria_evento (real)
MD-105 flow (MD) → FFA direct creation (real)
```

---

## ARCHITECTURE SCORE

| Component | Score |
|-----------|-------|
| SP Integrity | 8/10 |
| Event Coherence | 4/10 |
| Consistency | 9/10 |
| Canonical Alignment | 6/10 |
| Implementation Ready | 7/10 |