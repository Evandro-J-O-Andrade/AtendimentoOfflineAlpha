# MD-autenticacao — Core/Security

## 1. OBJETIVO
Autenticação via Portal

---

## 2. FLOW CANÔNICO

```text
Login (Portal)
    ↓
Credential Check
    ↓
Password Validate
    ↓
JWT Generation
    ↓
Session Create
    ↓
Redirect to Context Selector
```

---

## 3. ENTIDADES

### Tabelas
- auth_log — auditoria
- auth_token — tokens

---

## 4. SECURITY RULES
- Password strength
- Lock after failed attempts
- JWT HttpOnly cookie

---

## 5. DEPENDÊNCIAS
- MD-usuario, MD-sessao, MD-permissao

---

## STATUS
🟢 SYNCED