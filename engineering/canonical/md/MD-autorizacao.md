# MD-autorizacao — Core/Security

## 1. OBJETIVO
Autorização real-time via contexto

---

## 2. FLOW CANÔNICO

```text
Request
    ↓
Session Validate
    ↓
Context Check
    ↓
Role/Permissão Check
    ↓
ALLOW / DENY
```

---

## 3. DEPENDÊNCIAS
- MD-permissao, MD-sessao, MD-contexto

---

## STATUS
🟢 SYNCED