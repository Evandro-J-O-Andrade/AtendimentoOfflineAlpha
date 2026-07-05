# MD-pessoa — Core Identity

## 1. OBJETIVO
Raiz da arquitetura - entidade base para identidade

---

## 2. ESCOPO
Domínio: Core
Módulo: Identidade

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- pessoa - Tipo: CORE
- Primary Key: id_pessoa
- Foreign Keys: paciente→pessoa, usuario→pessoa

### Relacionamentos
```markdown
pessoa → paciente (FK)
pessoa → usuario (FK)
pessoa → profissional (FK)
```

---

## 4. PROCEDURES
- sp_pessoa_create — Tipo: DISPATCHER
- sp_pessoa_update — Tipo: EXECUTOR

---

## 5. EVENTOS
- pessoa_evento → kernel_ledger synchronization

---

## 6. REGRAS DE NEGÓCIO
- BR-001 — Validação completa de dados
- BR-002 — Auditoria de alterações

---

## 7. APIs
- /api/pessoas — Verbo: POST/GET/PUT
- /api/pessoas/{id} — Verbo: GET/DELETE

---

## 8. FRONTS RELACIONADOS
- FRONT-001 — Cadastro de Pessoa

---

## 9. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 10. DEPENDÊNCIAS
- MD-002 — Usuario
- MD-015 — Paciente

---

## 11. STATUS
🟢 SYNCED — alinhado ao dump

---

*Gerado pelo KILO ENGINE v8 - 2026-07-05*