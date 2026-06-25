# MAP-012 — Security & Identity Deep Domain

## Status
CANÔNICO
DOMÍNIO SECURITY
FREEZE ARQUITETURAL 2.0

---

# 1. Objetivo do Domínio

Definir o domínio de segurança e identidade avançada.

Controla: Autenticação, autorização, sessão, dispositivos, políticas.

---

# 2. Lei Fundamental

```text
Autenticação é diferente de autorização. Sessão é recurso controlado.
```

---

# 3. Fluxo Macro

```text
Credencial → Autenticacao → Sessao → Autorizacao → Operacao
```

---

# 4. Entidades Centrais

```text
Credencial
Sessao
Politica
Dispositivo
Token
Claim
AuditoriaAcesso
```

---

# 5. Eventos Gerados

```text
AUTH_ATTEMPTED
SESSION_STARTED
SESSION_EXPIRED
TOKEN_REFRESHED
DEVICE_REGISTERED
POLICY_VIOLATED
ACCESS_DENIED
```

---

# 6. Regras Macro

- JWT é HttpOnly + Secure
- Display possui certificado próprio
- Sessão tem timeout configurável
- Auditoria é obrigatória

---

# 7. Integrações

```text
MD-002 Autenticacao
MD-034 IAM
MAP-011 Admin (Tenants)
MD-136 Event Driven (Eventos)
```