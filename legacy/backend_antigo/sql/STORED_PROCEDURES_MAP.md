# ⚙️ MAPEAMENTO DE LÓGICA PROCEDURAL - DUMP 20260606

## 🎭 DISPATCHERS (ESPINHA DORSAL)
| Procedure | Função |
| :--- | :--- |
| `sp_master_dispatcher` | Ponto de entrada para comandos JSON. |
| `sp_master_dispatcher_runtime` | Executor de ações de negócio em tempo real. |
| `sp_master_routes` | Orquestrador de rotas de sistema. |
| `sp_master_query_dispatcher` | Gateway para consultas parametrizadas. |
| `sp_dispatcher_kernel` | Roteamento de operações de baixo nível. |

## 🔄 WORKFLOW ENGINE
| Procedure | Função |
| :--- | :--- |
| `sp_ffa_orquestrador_transicao` | Valida e executa mudanças de fase no processo. |
| `sp_fluxo_executor_matriz` | Consulta as regras de transição permitidas. |
| `sp_validar_transicao_fluxo` | Impede estados ilegais. |

## 🔐 SECURITY & SESSION
| Procedure | Função |
| :--- | :--- |
| `sp_sessao_assert` | Garante que o usuário tem sessão e contexto válidos. |
| `sp_tenant_enforce_not_null` | Impede transações sem identificação de Tenant (SaaS Guard). |
| `sp_auth_contexto_set` | Define Unidade/Local/Perfil de trabalho. |
| `sp_permissao_assert` | Valida RBAC antes de qualquer operação. |
| `sp_guardiao_runtime_final` | Validador final de integridade de transação. |

## 📝 LEDGER & AUDIT
| Procedure | Função |
| :--- | :--- |
| `sp_ledger_registrar_evento` | Gravação imutável no ledger de auditoria. |
| `sp_master_registrar_erro` | Captura falhas para análise de governança. |
| `sp_auditoria_evento_registrar` | Registro de eventos operacionais simples. |