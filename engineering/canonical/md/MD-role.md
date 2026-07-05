# MD-role — Core/IAM

## 1. OBJETIVO
Role - agrupamento de permissões para perfis

---

## 2. ESCOPO
Domínio: Core/IAM
Módulo: Roles

---

## 3. MODEL DE ATRIBUIÇÃO

```text
Role
    ↓
Permissões agrupadas
    ↓
Profile assignment
    ↓
Context override
    ↓
DECISÃO FINAL
```

---

## 4. TIPOS DE ROLE

### System Roles
- admin_master
- operador_basico

### Domain Roles  
- his_doctor
- his_nurse
- portal_admin

---

## 5. ENTIDADES CANÔNICAS

### Tabelas
- papel — Tipo: CORE
- papel_funcao — Tipo: LINK

---

## 6. PROCEDURES
- sp_role_assign — Tipo: EXECUTOR

---

## 7. EVENTOS
- papel_evento → kernel_ledger

---

## 8. DEPENDÊNCIAS
- MD-permissao

---

## STATUS
🟢 SYNCED