# KNOWLEDGE ENGINE — KILO v7

## 🎯 OBJETIVO

Carregar conhecimento de todas as fontes do projeto sem depender exclusivamente dos dumps.

---

## 📚 SOURCES ORDER

1. `canonical/` → Arquitetura aprovada
2. `inventory/` → Estado conhecido
3. `metadata/` → Relacionamentos
4. `reports/` → Histórico de auditoria
5. `dumps/` → Atualização (se disponível)
6. `workspace/` → Trabalhos em andamento

---

## 🔍 AUTO DISCOVERY PATHS

```
engineering/inventory/**/*.json
engineering/metadata/**/*.json
engineering/canonical/**/*.md
engineering/reports/**/*.md
engineering/dumps/**/*.sql
engineering/dumps/**/*.dump
engineering/dumps/**/*.bak
```

---

## 🧠 FLUXO

```text
Knowledge Loader
    ↓
Load Canonical (priority 1)
    ↓
Load Inventory (priority 2)
    ↓
Load Metadata (priority 3)
    ↓
Load Reports (priority 4)
    ↓
Load Dumps (priority 5)
    ↓
Compare New vs Existing
    ↓
Generate Diff Report
    ↓
Sync Only Changes
```

---

## 💡 REGRA

Sem dumps → KILO continua usando conhecimento existente.
Novos dumps → KILO sincroniza apenas diferenças.

---

*Knowledge Engine: fonte independente do KILO*