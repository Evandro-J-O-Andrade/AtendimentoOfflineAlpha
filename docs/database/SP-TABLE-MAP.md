# SP-TABLE-MAP.md — Procedure → Tabelas

> Seed 2026-07-09 (evidência: SPs do dump + `DUMP-001-audit.md`). Para demais SPs, ver ficha
> individual em `procedures/<sp>.md`. Formato: `SP | Lê | Escreve | Audita`.

## Auth / Sessão / Contexto

| SP | Lê | Escreve | Audita |
| :--- | :--- | :--- | :--- |
| `sp_master_login` (AUTH.LOGIN.REQUEST) | `usuario`, `login_tentativa` | `sessao_usuario` | `login_tentativa`, `auditoria_evento` |
| `sp_sessao_contexto_get` | `sessao_usuario` | — | — |
| `sp_sessao_contexto_set` | `sessao_usuario` | `sessao_usuario` | `auditoria_evento` |
| `sp_auth_contexto_get` | `sessao_usuario`, `usuario_unidade`+`unidade`, `usuario_perfil`+`perfil`, `usuario_local`+`local` | — | — |
| `sp_auth_contexto_set` | `sessao_usuario`, `usuario_unidade`, `usuario_perfil`, `usuario_local` | `sessao_usuario`, `usuario_contexto` | `auditoria_evento` |
| `sp_sessao_assert` | `sessao_usuario` | — | — |
| `sp_guardiao_absoluto` | `sessao_usuario` | — | — |
| `sp_guardiao_runtime_assert` | `guardiao_acl_runtime` | — | — |

## Portal / Navegação

| SP | Lê | Escreve | Audita |
| :--- | :--- | :--- | :--- |
| `sp_auth_menu_get` | `sessao_usuario`, `permissao`, `perfil_permissao`, `permissao_local` | `menu_evento` | `menu_evento` |
| `sp_auth_permissions_evaluate` | ❌ **AUSENTE NO DUMP** (ADAPT de `sp_auth_menu_get`) | — | — |

## Kernel / Runtime

| SP | Lê | Escreve | Audita |
| :--- | :--- | :--- | :--- |
| `sp_dispatcher_kernel` | — | `runtime_execution_queue` | — |
| `sp_kernel_writer_lock` / `sp_kernel_writer_unlock` | `kernel_runtime_single_writer_lock` / `kernel_single_writer_lock` | lock | — |
| `sp_executor_assistencial_*` | `atendimento*`, `triagem`, `evolucao_*` | `atendimento*`, `assistencial_*` | `auditoria_*` |
| `sp_executor_estoque_runtime` | `estoque_*` | `estoque_movimento*`, `estoque_saldo*` | `estoque_audit_stream` |
| `sp_guardiao_runtime_decidir` / `sp_guardiao_runtime_final` | `guardiao_acl_runtime` | `kernel_ledger` | `kernel_ledger` |

## Fila / Senha

| SP | Lê | Escreve | Audita |
| :--- | :--- | :--- | :--- |
| `sp_fila_chamar_proxima` / `sp_chamar_senha` | `fila_operacional`, `senha`, `local_fila` | `senha`, `fila_evento` | `auditoria_fila` |
| `sp_criar_senha` / `sp_finalizar_senha` | `senha`, `fila_operacional` | `senha`, `senha_eventos` | — |

## Farmácia / FFA

| SP | Lê | Escreve | Audita |
| :--- | :--- | :--- | :--- |
| `sp_farm_dispensacao_criar` / `sp_farmacia_dispensar_registrar` | `farm_dispensacao`, `estoque_*` | `farm_dispensacao_item`, `estoque_movimento*` | `auditoria_ffa` |
| `sp_ffa_orquestrador_transicao` | `ffa`, `ffa_item` | `ffa_estado`, `ffa_historico_status` | `evento_ffa` |

> ⚠️ Este mapa é **seed**. As fichas completas (com colunas e FK) estão em `procedures/*.md`.
> Ao criar/alterar SP, atualize esta tabela e a ficha correspondente.
