# MD-sessao — Core

## 1. OBJETIVO
Gerenciamento de sessão do usuário

---

## 2. ESCOPO
Domínio: Core
Módulo: Sessão

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- sessao_usuario — Tipo: CORE
- sessao_ativa — Tipo: SUPPORT
- sessao_contexto_historico — Tipo: SUPPORT
- Primary Key: id_sessao_usuario
- Foreign Keys:
  - sessao_usuario→usuario (FK)

### Relacionamentos
```markdown
usuario → sessao_usuario (1:N)
sessao_usuario → contexto (N:M)
```

---

## 4. PROCEDURES
- sp_sessao_create — Tipo: DISPATCHER
- sp_sessao_assert — Tipo: GUARD

---

## 5. EVENTOS
- sessao_evento → kernel_ledger

---

## 6. REGRAS DE NEGÓCIO
- BR-003 — Validação de sessão ativa
- BR-004 — Timeout de inatividade

---

## 7. APIs
- /api/auth/session — Verbo: POST
- /api/auth/validate — Verbo: GET

---

## 8. FRONTS RELACIONADOS
- FRONT-001 — Login

---

## 9. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 10. DEPENDÊNCIAS
- MD-usuario — Sessão

---

## 11. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: SP-First, Event-Driven
MDs relacionados: MD-pessoa, MD-usuario
Tabelas: sessao_usuario, sessao_ativa