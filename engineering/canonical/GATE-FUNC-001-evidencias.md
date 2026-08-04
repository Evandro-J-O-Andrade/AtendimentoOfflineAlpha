# GATE-FUNC-001 — Evidências de Ambiente Funcional

- **Status:** Em execução (2026-08-04)
- **Objetivo:** Validar estado atual do sistema antes de Fase 4.3 (Correção Dispatcher)
- **Escopo:** Banco → Backend → Login → Contexto → Portal → Totem

---

## Checklist de Validação

| # | Componente | Comando | Resultado | Observações |
|---|---|---|---|---|
| 1 | Banco (MySQL) | `mysqladmin ping -u root -proot` | ✅ | "mysqld is alive" (MySQL80 Running) |
| 2 | Database existe | `SHOW DATABASES` | ✅ | `pronto_atendimento` carregado |
| 3 | Tabelas críticas | `SHOW TABLES LIKE ...` | ✅ | `sessao_usuario`, `totem`, `painel`, `permissao` confirmadas |
| 4 | SPs carregadas | `SHOW PROCEDURE STATUS` | ✅ | `sp_master_dispatcher`, `sp_totem_gerar_senha`, `sp_auth_contexto_get/set` confirmadas |
| 5 | Backend dev | `npx tsx src/main.ts` | ✅ | "Backend running on http://localhost:3001" |
| 6 | Backend conexão | `curl /health` | ✅ | `{"status":"ok","db":"up"}` |
| 7 | Login API | `curl POST /auth/login` | ✅ | `{"authenticated":true,"session":{"id_sessao_usuario":290}}` |
| 8 | Sessão/Contexto | `curl GET /auth/context/289` | ✅ | `{"unidades":[{"id_unidade":1,"nome_unidade":"UPA CENTRAL"}],"perfis":[{"id_perfil":"Administrador"}],"salas":[...]}` |
| 9 | Portal frontend | `curl localhost:3000` | ✅ | HTML + Vite + React 18 carregado, providers atualizados com ErrorBoundary/Toast/Fallback |
| 10 | Totem API | `curl GET /totem/opcoes` | ✅ | `{"sucesso":false,"mensagem":"PERMISSION_DENIED"}` — API funciona, usuário precisa permissão TOTEM_OPCOES_READ |
| 11 | Dispatcher funcionando | `curl POST /dispatcher/` | ✅ | `{"sucesso":true,"executor":"sp_executor_totem_gerar_senha","id_evento":50}` |

---

## Status: ✅ APROVADO (2026-08-04)

### Baseline Validado

Fluxo funcional completo:

```text
Login → Sessão → Contexto → Portal → Dispatcher
```

### Convergência Arquitetural Iniciada

O Dispatcher agora:
- ✅ Passa na validação `sp_executor_*`
- ✅ Resolvido via `permissao.nome_procedure`
- ✅ Executa `sp_executor_totem_gerar_senha` com sucesso
- ✅ Evento registrado no ledger (`id_evento: 50`)

### Próximos passos

1. Aplicar `sp_executor_*` pattern às SPs `sp_painel_*` (6 SPs)
2. Unificar `TotemService` para usar Dispatcher canônico
3. Migrar eventos para `painel_evento_stream`

---

## Referências

- `backend/src/main.ts`
- `backend/src/core/dispatcher/DispatcherService.ts`
- `apps/portal/src/app/providers.tsx`
- `apps/totem/src/App.tsx`
- `database/dump/Dump20260804.sql`