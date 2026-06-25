# MAP-011 — Admin & Governance Domain

## Status
CANÔNICO
DOMÍNIO GOVERNANÇA
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de administração e governança multi-tenant.

Controla: Tenants, unidades, permissões, segurança, configurações.

---

# 2. Lei Fundamental

```text
Tenant é fronteira de isolamento. Unidade é contexto operacional.
```

---

# 3. Fluxo Macro

```text
Tenant → Unidade → Setor → Perfil → Permissao → Configuracao
```

---

# 4. Entidades Centrais

```text
Tenant
Unidade
Setor
Perfil
Permissao
Configuracao
Parametrizacao
Sessao
```

---

# 5. Eventos Gerados

```text
TENANT_CREATED
UNIT_ADDED
PROFILE_ASSIGNED
PERMISSION_CHANGED
CONFIG_UPDATED
SESSION_STARTED
SESSION_ENDED
```

---

# 6. Regras Macro

- Tenant nunca compartilha dados diretamente
- Unidade possui configuração própria
- Perfil é abstração de papéis
- Permissão é granular e auditável

---

# 7. Integrações

```text
MD-017 Multi-Tenant
MD-034 IAM
MD-136 Event Driven (Eventos)
MAP-012 Security (Autenticação)
```