# MD-AUDITORIA-003 — Core Tables Catalog Matrix

## Status
Catálogo de referência rápida. Use este documento para saber "onde está" cada entidade do Core.

---

## Core Tables by Layer

### IAM / Identity Layer
| Tabela | Doc | Campos-Chave | Observações |
|--------|-----|--------------|-------------|
| `pessoa` | ✅ `docs/tables/pessoa.md` | id_pessoa, tipo_pessoa, nome, data_nascimento | Tabela mestre de todas as pessoas (paciente, profissional, etc.) |
| `usuario` | ✅ `docs/tables/usuario.md` | id_usuario, login, senha_hash, id_entidade | Credentials + vinculo com pessoa |
| `saas_entidade` | ✅ EXISTS | id_entidade, nome, cnpj | Tenant/Multi-tenancy |
| `auth_sessao` | ✅ `docs/tables/auth_sessao.md` | id_sessao_usuario, id_usuario, token_sessao, id_entidade, id_unidade, id_local | Sessão com contexto |
| `auth_token` | ✅ `docs/tables/auth_token.md` | id_token, uuid_runtime, token_hash, expira_em | Token UUID por sessão |
| `auth_auditoria` | ✅ `docs/tables/auth_audit.md` | - | Logs de autenticação |

### Authorization Layer
| Tabela | Doc | Campos-Chave | Observações |
|--------|-----|--------------|-------------|
| `perfil` | ✅ EXISTS | id_perfil, nome, id_entidade | Papel de acesso |
| `permissao` | ✅ `docs/tables/permissao.md` | id_permissao, codigo, dominio, modulo, nome_procedure | Catálogo de permissões |
| `perfil_permissao` | ✅ `docs/tables/perfil_permissao.md` | id_perfil, id_permissao | N:N perfil ↔ permissao |
| `permissao_local` | ✅ `docs/tables/permissao_local.md` | id_permissao, id_local | Permissão por local (CRÍTICA) |
| `usuario_perfil` | ✅ EXISTS | id_usuario, id_perfil, id_unidade | Usuário pode ter perfis diferentes por unidade |
| `usuario_unidade` | ✅ EXISTS | id_usuario, id_unidade | Vinculo usuário ↔ unidade |
| `usuario_local` | ✅ `docs/tables/usuario_local.md` | id_usuario, id_local | Locais onde usuário pode atuar |

### Portal / Module Layer
| Tabela | Doc | Campos-Chave | Observações |
|--------|-----|--------------|-------------|
| `portal_categoria` | ⚠️ Stage200.sql only, no MD | id_portal_categoria, nome | Categorias de notícias |
| `portal_noticia` | ⚠️ Stage200.sql only, no MD | id_portal_noticia, titulo, conteudo | Notícias do portal |
| `aplicativo` | ❌ MISSING | codigo, nome, icone, requer_contexto | Tabela canônica de módulos (precisa ser criada) |
| `usuario_aplicativo` | ❌ MISSING | id_usuario, id_aplicativo | Vinculo usuário ↔ aplicativo |

### Runtime Layer
| Tabela | Doc | Campos-Chave | Observações |
|--------|-----|--------------|-------------|
| `runtime_contexto` | ✅ `docs/tables/runtime_contexto.md` | id_sessao_usuario, id_unidade, id_local_operacional, id_paciente, id_ffa, contexto_clinico | Contexto clínico da sessão |
| `runtime_execution_queue` | ✅ EXISTS | uuid_execution, acao, status, payload | Fila assíncrona |
| `runtime_api_session_token` | ✅ EXISTS | uuid_runtime, token_hash, expira_em | Token para APIs stateless |
| `runtime_lock_semantico` | ✅ EXISTS | - | Lock distribuído |
| `runtime_sync_queue` | ✅ EXISTS | - | Operação offline-first |

### Ledger / Event Store
| Tabela | Doc | Campos-Chave | Observações |
|--------|-----|--------------|-------------|
| `atendimento_evento_ledger` | ✅ `docs/tables/atendimento_evento_ledger.md` | uuid_transacao, acao, estado_origem, estado_destino, payload_original | Evento imutável, UUID |
| `auditoria_evento` | ✅ EXISTS | - | Log de eventos |
| `auditoria_ledger` | ⚠️ RAW only | - | Ledger de auditoria |
| `auditoria_contexto` | ✅ EXISTS | - | Auditoria de mudanças de contexto |
| `workflow_ffa_evento` | ✅ EXISTS | - | Eventos de workflow |

---

## Core Procedures Quick Reference

### Auth Lifecycle
| SP | Status | Função |
|----|--------|--------|
| `sp_master_login` | ✅ EXISTS | Login monolítico, retorna sessão sem contexto |
| `sp_master_routes` | ✅ EXISTS | Orquestrador de rotas |
| `sp_core_session_guard` | ❌ MISSING | Guard de sessão (referenciado mas não existe) |

### Context Management
| SP | Status | Função |
|----|--------|--------|
| `sp_auth_contexto_get` | ✅ EXISTS | Lista unidades, perfis, locais disponíveis (precisa ser `sp_module_context_resolver`) |
| `sp_auth_contexto_set` | ✅ EXISTS | Define contexto (precisa ser renomeado) |
| `sp_sessao_contexto_get` | ✅ EXISTS | Versão legada, duplica |
| `sp_sessao_contexto_set` | ✅ EXISTS | Versão legada, duplica |

### Menu / Portal
| SP | Status | Função |
|----|--------|--------|
| `sp_auth_menu_get` | ✅ EXISTS | Menu dinâmico requer contexto pré-definido |
| `sp_module_portal_resolver` | ❌ MISSING | Lista módulos disponíveis pós-login |

### Dispatcher / Execution
| SP | Status | Função |
|----|--------|--------|
| `sp_dispatcher_kernel` | ✅ EXISTS | Enfileira ação no runtime |
| `sp_kernel_writer_lock` | ✅ EXISTS | Lock de escrita |
| `sp_runtime_decision_engine` | ✅ EXISTS | Motor de decisão |

---

## Como Usar Este Catálogo

### Exemplo: Criar tela de seleção de módulo no React
```
1. Chamar sp_master_login → obtém sessão (id_sessao_usuario)
2. Chamar sp_module_portal_resolver(id_usuario, id_entidade) → lista módulos
3. Usuário escolhe "HIS"
4. Chamar sp_module_context_resolver(id_sessao_usuario, 'HIS') → pergunta unidade
5. sp_module_context_bind → inicia workspace
```

### Exemplo: Auditoria de ação
```
Qualquer SP executa:
→ gera evento em atendimento_evento_ledger (UUID, fingerprint)
→ grava audit em auditoria_evento
→ faz rollback se erro
```

---

## Gaps Mapeados (Priority Queue)

| # | Gap | Priority | Quem Resolve |
|---|-----|----------|--------------|
| 1 | sp_core_session_guard missing | 🔴 CRITICAL | auth_dispatch layer |
| 2 | sp_module_portal_resolver missing | 🔴 CRITICAL | portal module |
| 3 | Tabela aplicativo missing | 🔴 CRITICAL | core schema |
| 4 | Renomear sp_auth_contexto_* | 🟡 MEDIUM | refactor auth |
| 5 | Documentar ledger_* | 🟢 LOW | docs team |