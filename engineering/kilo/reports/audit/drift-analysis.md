# DRIFT ANALYSIS — KILO v7

## 🟢 REAL-DOMINANT COMPONENTS

| Component | MD Ref | Real Impl | Status |
|-----------|--------|-----------|--------|
| Dispatcher | sp_master_dispatcher | sp_gatekeeper_assistencial | DUMP_DOMINANT |
| Orchestrator | sp_master_orquestradora | sp_ffa_orquestrador_transicao | DUMP_DOMINANT |
| Queue | sp_fila_* | sp_fila_chamar_proxima | ALIGNED |

---

## 🔴 MD-GHOST COMPONENTS (exist in MD but not used)

| Component | Status | Action |
|-----------|--------|--------|
| sp_master_dispatcher | GHOST | DELETE / RENAME |
| sp_master_orquestradora | GHOST | DELETE / RENAME |
| kernel_ledger | GHOST | IMPLEMENT migration path |
| sp_senha_emitir | MISSING | CREATE |
| MD-105 full flow | DIVERGENT | PATCH |

---

## 🟡 DRIFT PATTERNS DETECTED

### Pattern 1: SP Renaming
```
MD: sp_master_dispatcher
Real: sp_gatekeeper_assistencial
Resolution: Canonize sp_gatekeeper
```

### Pattern 2: Event Fragmentation
```
MD: kernel_ledger (single event store)
Real: 28 event tables
Resolution: Migration bridge required
```

### Pattern 3: Flow Violation
```
MD: Senha → Fila → FFA → Atendimento
Real: FFA direct creation
Resolution: Create sp_senha_emitir first
```

---

## 📊 DRIFT SCORE

```
TOTAL_TABLES: 478
TOTAL_SPS: 19
MD_REFERENCES: 6
MISSING_CRITICAL: 3
GHOST_COMPONENTS: 4

DRIFT_PERCENTAGE: 24%
```