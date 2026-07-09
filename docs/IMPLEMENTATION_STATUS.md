# Implementation Status

Acompanhamento oficial das implementações frente aos documentos canônicos.

| Documento   | Código     | Status                    | Nota                          |
| ----------- | ---------- | ------------------------- | ----------------------------- |
| FRONT-000   | Plataforma | ✅ Approved / Foundation  | Construção concluída          |
| FRONT-001   | Login      | ✅ Implementado      | Fluxo operacional; redirecionamento direto para /portal é temporário até FRONT-002 |
| FRONT-002   | Contexto   | ✅ Implementado      | ContextSelectionPage consumindo /auth/context e /auth/context/select |
| BACKEND     | CORE-001   | ✅ Implementado      | Auth Service + endpoints /auth/* consumindo sp_master_login, sp_sessao_contexto_get, sp_auth_contexto_get |
| BACKEND     | CORE-002   | ✅ Implementado      | Context endpoints /auth/context e /auth/context/select |
| BACKEND     | CORE-003   | ✅ Implementado      | PortalService + endpoints /portal/* consumindo sp_auth_menu_get |
| FRONT-003   | Portal     | 🚧 Backend conectado | PortalRuntimeComposer consumindo /portal/runtime quando sessão existe |
| FRONT-002   | Contexto   | ⏳ Planejado              | Aguardando execução de FRONT-001 |
| FRONT-003   | Portal     | ⏳ Planejado              | Shell/renderer existente      |
| FRONT-004   | Registry   | ⏳ Planejado              |                               |
| FRONT-005   | Dashboard  | ⏳ Planejado              |                               |

## Packages

| Package        | Status       |
| -------------- | ------------ |
| contracts      | ✅ Foundation |
| api            | ✅ Foundation |
| auth           | ✅ Foundation |
| runtime        | ✅ Foundation |

## Apps

| App        | Status       |
| ---------- | ------------ |
| portal     | 🚧 Integrado |
| management | ⏳ Planejado |
| his        | ⏳ Planejado |

## Regra

Nenhuma página é considerada concluída sem unir:
- documento canônico aprovado,
- contrato em `packages/contracts`,
- execução em runtime,
- typecheck e sem dependências proibidas.
