# BACKEND.md — Inventário Vivo do Backend

> Seed 2026-07-09. Fonte: `DUMP-001-audit.md` + leitura de `backend/src`.
> Mapeia services → SPs. Antes de alterar um service, consulte `PROCEDURES.md` / `CALL-GRAPH.md`.

## Services → SPs

| Service | Método | SP chamada | No dump? |
| :--- | :--- | :--- | :--- |
| `AuthService.login` | `AuthService.ts:17` | `sp_master_login` (AUTH.LOGIN.REQUEST) | ✅ |
| `AuthService.session` | `AuthService.ts:64` | `sp_sessao_contexto_get` | ✅ |
| `AuthService.context` | `AuthService.ts:85` | `sp_auth_contexto_get` | ✅ |
| `AuthService.selectContext` | `AuthService.ts:105` | `sp_auth_contexto_set` | ✅ |
| `PortalService.navigation` | `PortalService.ts:18` | `sp_auth_menu_get` | ✅ |
| `PermissionService.evaluate` | `PermissionService.ts:17` | `sp_auth_permissions_evaluate` | ❌ **AUSENTE** |

## Rotas

- `backend/src/routes/auth.ts` — `/login`, `/session`, `/logout`, `/refresh`, `/context`, `/context/select`
  ⚠️ **R3:** router definido **duas vezes** (linhas ~7-71 e ~73-120 idênticas) — remover duplicata.
- `backend/src/routes/portal.ts` — `/runtime`, `/permissions`, `/navigation`, `/applications`,
  `/branding`, `/dashboard`, `/widgets`, `/notifications`

## Composição do PortalRuntime (PortalService.runtime)

```text
navigation  → sp_auth_menu_get
applications (DERIVADO de navigation, sem SP própria)
branding     (hardcoded)
dashboard    (hardcoded, widgets:[])
widgets      → []   (sem fonte)
notifications→ []
permissions  → sp_auth_permissions_evaluate  ❌
```

## Regra para IA

Não criar novo service/SP sem antes confirmar em `PROCEDURES.md`. Se a SP já existe (REUSE) ou
pode ser adaptada (ADAPT), não propor nova. O único objeto faltante hoje é
`sp_auth_permissions_evaluate` (ADAPT de `sp_auth_menu_get`, CORE-005).
