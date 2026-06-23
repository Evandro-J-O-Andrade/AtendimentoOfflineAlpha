# FRONT-082 — Role & Permission Studio Experience

## Status

Documento Canônico de Frontend.
Define o estúdio visual de permissões.

---

## Objetivo

Criar um estúdio visual de permissões RBAC + ABAC.

---

## Estrutura

```text
Roles

Permissions

Policies

Constraints

Scopes
```

---

## Modelo

```text
RBAC + ABAC híbrido
```

---

## Exemplo

```text
Médico
→ pode acessar pacientes
→ dentro da sua unidade
→ dentro do seu turno
```

---

## Integrações

| MD / FRONT | Finalidade |
|-----------|-----------|
| FRONT-081 — Identity Access | IAM |
| MD-107 — Tenant Architecture | Tenant |
| FRONT-042 — IAM UX | IAM |