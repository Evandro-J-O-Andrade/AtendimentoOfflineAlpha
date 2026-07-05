# MD-usuario — Core/IAM

## 1. OBJETIVO
Raiz da autenticação - relaciona Pessoa ao Portal

---

## 2. ESCOPO
Domínio: Core/IAM
Módulo: Autenticação

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- usuario — Tipo: CORE
- usuario_senha_historico — Tipo: SUPPORT
- usuario_perfil — Tipo: LINK
- Primary Key: id_usuario
- Foreign Keys: 
  - usuario→pessoa (FK)
  - usuario→unidade (FK)

### Relacionamentos
```markdown
usuario → pessoa (1:1)
usuario → sessao_usuario (1:N)
usuario → perfil (N:M via usuario_perfil)
```

---

## 4. PROCEDURES
- sp_usuario_create — Tipo: DISPATCHER
- sp_usuario_login — Tipo: EXECUTOR
- sp_usuario_authenticate — Tipo: GUARD

---

## 5. EVENTOS
- usuario_log_acesso → kernel_ledger
- usuario_evento → kernel_ledger

---

## 6. REGRAS DE NEGÓCIO
- BR-001 — Login com validação de credenciais
- BR-002 — Bloqueio após tentativas falhas

---

## 7. APIs
- /api/auth/login — Verbo: POST
- /api/usuarios/{id} — Verbo: GET/PUT

---

## 8. FRONTS RELACIONADOS
- FRONT-001 — Login
- FRONT-002 — Dashboard

---

## 9. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 10. DEPENDÊNCIAS
- MD-pessoa — Identidade

---

## 11. STATUS
🟢 SYNCED — alinhado ao dump