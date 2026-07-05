# MD-permissao — Core/IAM

## 1. OBJETIVO
Motor de autorização - definição do controle de acesso

---

## 2. ESCOPO
Domínio: Core/IAM  
Módulo: Autorização

---

## 3. MODEL DE DECISÃO (OBRIGATÓRIO)

```text
Pessoa
    ↓
Usuário
    ↓
Sessão
    ↓
Contexto (TENANT + UNIDADE)
    ↓
Perfil
    ↓
Role
    ↓
Permissão
    ↓
DECISÃO FINAL (ALLOW / DENY)
```

---

## 4. REGRA DE OURO

> **Permissão nunca existe fora de contexto.**

---

## 5. TIPOS DE PERMISSÃO

### Action-based
- create / read / update / delete

### Resource-based
- API / tela / módulo

### Domain-based
- Portal / HIS / Financeiro

### Context-based
- tenant / unidade / setor

### Event-based
- pode emitir / pode consumir

---

## 6. HIERARQUIA DE AUTORIZAÇÃO

```text
Role
    ↓
Perfil
    ↓
Permissões explícitas
    ↓
Overrides de contexto
    ↓
DECISÃO FINAL
```

---

## 7. ENTIDADES CANÔNICAS

### Tabelas
- permissao — Tipo: CORE
- perfil_permissao — Tipo: LINK
- role_permissao — Tipo: LINK

### Relacionamentos
```markdown
permissao → perfil (N:M via perfil_permissao)
permissao → role (N:M via role_permissao)
permissao → contexto (N:M)
```

---

## 8. PROCEDURES
- sp_permissao_check — Tipo: GUARD
- sp_permissao_validate — Tipo: EXECUTOR

---

## 9. EVENTOS
- permissao_evento → kernel_ledger

---

## 10. INTEGRAÇÃO OBRIGATÓRIA
- MD-contexto
- MD-usuario
- MD-sessao
- MD-portal
- MD-entidade

---

## 11. IMPACTO NO FRONT
- FRONT-001 Portal
- FRONT-002 Context Selector
- FRONT-003 Dashboard

---

## 12. DEPENDÊNCIAS
- MD-perfil — Base de permissões

---

## 13. STATUS
🟢 SYNCED — alinhado ao dump

---

## Rastreabilidade
Leis Canônicas: SP-First, Event-Driven, Portal-First
MDs relacionados: MD-pessoa, MD-usuario, MD-contexto