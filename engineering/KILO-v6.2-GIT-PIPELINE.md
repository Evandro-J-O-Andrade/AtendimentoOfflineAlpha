# KILO v6.2 — GIT PIPELINE ENGINE (CONTINUOUS ARCHITECTURE AUDIT)

## 🎯 OBJETIVO
Rodar KILO automaticamente em CI/CD: detecção contínua de drift

---

## 📦 PIPELINE CI/CD

```
git push
   ↓
extract dump snapshot
   ↓
RUN KILO ENGINE
   ↓
COMPARE /mds /brs /fronts
   ↓
DRIFT REPORT
   ↓
FAIL BUILD IF CRITICAL
```

---

## 🚨 DRIFT DETECTION RULES

| Check | Threshold | Action |
|-------|-----------|--------|
| Missing SP in MD | > 1 | WARNING |
| Event not canonical | > 50% | ERROR |
| Broken FK | any | FAIL BUILD |
| Orphan table | > 10 | WARNING |
| Flow divergence | > 15% | WARNING |

---

## 📊 PIPELINE REPORT OUTPUT

```yaml
DRIFT_SCORE:
  tables: 92%
  sps: 88%
  events: 64%

BREAKING_CHANGES:
  - sp_xxx removed
  - ffa_etapa missing

RECOMMENDATIONS:
  - regenerate MD-105
  - update FRONT-003
```

---

## 🔧 AUTO-HOOK CONFIG

```yaml
# .github/workflows/kilo-audit.yml
name: KILO Architecture Audit
on: [push, pull_request]
jobs:
  kilo-audit:
    runs-on: ubuntu-latest
    steps:
      - run: kilo-parser --dump docs/database/
      - run: kilo-diff --mds docs/canonical/
      - run: kilo-report --output audit/
      - run: kilo-validate --fail-on-drift
```

---

## 🧠 RESULTADO
Detecção automática de inconsistências arquiteturais antes do deploy