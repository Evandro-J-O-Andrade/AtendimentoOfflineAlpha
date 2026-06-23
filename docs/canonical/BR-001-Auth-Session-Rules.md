# BR-001 — Auth & Session Rules

## Status
Documento de Regras de Negócio.
Regras de autenticação e sessão.

---

## Lei Canônica BR-001-001
```text
Autenticação é validação de identidade.
Autorização é validação de contexto.
```

---

## Regras de Autenticação

### Login
```text
REGRA-001-01: Email deve ser único por tenant
REGRA-001-02: Password deve ter mínimo de 8 caracteres
REGRA-001-03: Conta bloqueada após 5 tentativas falhas
REGRA-001-04: MFA obrigatório para perfis críticos
REGRA-001-05: Sessão mínima de 15 minutos
REGRA-001-06: Sessão máxima de 8 horas
REGRA-001-07: Refresh token válido por 30 dias
```

### Password
```text
REGRA-001-08: Hash usando bcrypt/argon2
REGRA-001-09: Password expira em 90 dias
REGRA-001-10: Nova password não pode ser igual às 3 últimas
REGRA-001-11: Notificar admin após reset
REGRA-001-12: Bloquear após 3 resets em 24h
```

---

## Regras de Autorização

### Permissões
```text
REGRA-001-13: Permissão = recurso + ação
REGRA-001-14: Permission sempre acoplada a role
REGRA-001-15: Role herda permissions
REGRA-001-16: Contexto invalida permission
REGRA-001-17: Deny prevalece sobre allow
```

### Políticas
```text
REGRA-001-18: Policy pode negar independente de role
REGRA-001-19: Policy é JSON com regras ABAC
REGRA-001-20: Policy tem prioridade configurável
```

---

## Stored Procedures de Regra

### sp_auth_login_with_rules
Aplica todas regras de login

### sp_auth_validate_session
Valida sessão contra regras

### sp_auth_check_permission
Verifica permission + policy

---

## Eventos de Regra

### AuthLoginFailed
### AuthSessionExpired
### AuthPermissionDenied