# MD-perfil — Core/IAM

## 1. OBJETIVO
Perfil do usuário - define acesso e permissões

---

## 2. ESCOPO
Domínio: Core/IAM
Módulo: Perfil

---

## 3. ENTIDADES CANÔNICAS

### Tabelas
- perfil — Tipo: CORE
- perfil_permissao — Tipo: LINK
- papel — Tipo: SUPPORT
- Primary Key: id_perfil
- Foreign Keys:
  - perfil_permissao→perfil (FK)

### Relacionamentos
```markdown
perfil → permissao (N:M via perfil_permissao)
perfil → usuario (N:M via usuario_perfil)
perfil → papel (N:1)
```

---

## 4. ACCESS CONTROL MODEL

```text
Pessoa
    ↓
Usuário
    ↓
Perfil
    ↓
Permissões
    ↓
Operações
```

---

## 5. PROCEDURES
- sp_perfil_check — Tipo: GUARD
- sp_perfil_validate — Tipo: EXECUTOR

---

## 6. EVENTOS
- perfil_evento → kernel_ledger

---

## 7. PERMISSÕES
- Perfil admin: papel_perfil_admin

---

## 8. APIs
- /api/perfis — Verbo: GET/POST

---

## 9. FRONTS RELACIONADOS
- FRONT-005 — Gestão de Perfis

---

## 10. AUDITORIA
- kernel_ledger: ✅ IMPLEMENTED

---

## 11. DEPENDÊNCIAS
- MD-usuario — Perfil

---

## 12. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: SP-First, Event-Driven
MDs relacionados: MD-usuario, MD-contexto
Tabelas: perfil, perfil_permissao, papel