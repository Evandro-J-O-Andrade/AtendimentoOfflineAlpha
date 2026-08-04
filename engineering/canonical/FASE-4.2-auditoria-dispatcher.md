# FASE 4.2 — Auditoria do Dispatcher

- **Status:** Concluída (2026-08-04)
- **Base:** ADR-007 — Arquitetura de Painéis/Displays
- **Objetivo:** Auditar o estado atual do Kernel Dispatcher antes de correções

---

## 1. Estado Atual

### 1.1 Kernel Dispatcher

| Arquivo | Função |
|---|---|
| `backend/src/core/dispatcher/DispatcherService.ts` | Wrapper sobre `sp_master_dispatcher` |
| `backend/src/core/dispatcher/DispatcherController.ts` | Endpoint POST `/dispatcher/` |
| `backend/src/routes/dispatcher.ts` | Roteamento |

**Fluxo atual:**
```text
Frontend
    ↓
POST /dispatcher/
    ↓
DispatcherService.dispatch(modulo, acao, payload, id_sessao)
    ↓
CALL sp_master_dispatcher(p_id_sessao, p_uuid, p_dominio, p_acao, p_id_referencia, p_payload)
    ↓
SELECT nome_procedure FROM permissao WHERE codigo = CONCAT(p_dominio, '.', p_acao)
    ↓
VALIDA: nome_procedure LIKE 'sp_executor_%'
    ↓
EXECUTA: CALL <nome_procedure>(...)
```

### 1.2 Totem Consumer

| Arquivo | Função |
|---|---|
| `backend/src/main.ts:37` | `app.use('/totem', totemRoutes)` |
| `backend/src/core/totem/TotemController.ts:7-59` | 3 endpoints: `/opcoes`, `/plantao-medico`, `/gerar-senha` |
| `backend/src/core/totem/TotemService.ts:40-122` | Dispatch hardcoded `modulo: 'totem', acao: 'gerar_senha'` |

### 1.3 Registry/Tabelas de eventos

| Tabela (dump) | Colunas-chave | Registros | Observação |
|---|---|---|---|
| `permissao` (14579) | `codigo`, `nome_procedure` (toda NULL) | 36 | Registry vazio |
| `painel_evento_stream` (11157) | `id_painel`, `id_lane`, `id_local`, `payload`, `processado` | 0 | Stream vazia |
| `painel_consumo_evento` (11127) | `origem`, `id_evento`, `painel_tipo` | 0 | Consumo vazio |
| `totem_evento` (15537) | `id_totem`, `evento`, `detalhe` | 43 | Eventos isolados do stream |
| `atendimento_evento` (1354) | `id_atendimento`, `evento`, `payload` | ? | Eventos assistenciais |
| `erro_evento` (4153) | `dominio`, `acao`, `mensagem_erro` | ? | Erros do dispatcher |

---

## 2. Problemas Encontrados

### Tipo A — Acoplamento indevido (Kernel conhece Tipos de Painel)

| # | Problema | Localização |
|---|---|---|
| 1 | Dispatcher valida `sp_executor_%` mas `sp_painel_*` e `sp_totem_gerar_senha` não seguem padrão | `sp_master_dispatcher` (dump:25776) |
| 2 | `TotemService` hardcodeia `modulo: 'totem', acao: 'gerar_senha'` | `TotemService.ts:43-48, 63-66, 83-94` |
| 3 | Totem exposto via rota standalone `/totem`, não pelo Dispatcher | `main.ts:37` |
| 4 | Permissões hardcoded (`TOTEM_OPCOES_READ`, `TOTEM_SENHA_GERAR`, etc.) | `TotemService.ts:41, 60, 79` |

### Tipo B — Eventos sem registry

| # | Problema | Localização |
|---|---|---|
| 5 | `permissao.nome_procedure` = NULL para todas as 36 permissões | `permissao` (dump:14609) |
| 6 | `painel_evento_stream` e `painel_consumo_evento` com 0 registros | dump |

### Tipo C — Runtime sem assinatura

| # | Problema | Localização |
|---|---|---|
| 7 | Dispatcher usa `modulo/acao` em vez de `evento/tipo_evento` | `DispatcherController.ts:20-21` |
| 8 | Eventos de totem (`totem_evento`) não fluem pelo stream canônico | `TotemService.ts:103-109` |

---

## 3. Divergências Contra ADR-007

| Regra ADR | Implementação | Status |
|---|---|---|
| Runtime consome eventos genéricos | Dispatcher hardcodeia `modulo`/`acao` | 🔴 |
| Kernel não conhece Tipos de Painel | `modulo:'totem'` no TotemService | 🔴 |
| Eventos distribuídos via stream | `painel_evento_stream` vazia | 🔴 |
| Comportamento nasce da Configuração | Hardcoded em TotemService | 🔴 |
| Kernel → Runtime → Painel → Config | Dispatcher confunde níveis | 🔴 |

---

## 4. Plano de Correção

### Prioridade 1 (Crítico)

| Ação | Detalhe | Esforço |
|---|---|---|
| Renomear `sp_painel_*` → `sp_executor_painel_*` | 6 SPs (dump:28484, 28577, 28669, 28861, 28958, 29045) | Médio |
| Renomear `sp_totem_gerar_senha` → `sp_executor_totem_gerar_senha` | dump:32603 | Baixo |
| Preencher `permissao.nome_procedure` (36 registros) | dump:14609 | Médio |

### Prioridade 2 (Alto)

| Ação | Detalhe | Esforço |
|---|---|---|
| Unificar API Dispatcher: `modulo/acao` → `evento/tipo_evento` | `DispatcherController.ts`, `DispatcherService.ts` | Alto |
| Migrar `/totem` para Dispatcher unificado | Unificar com `/dispatcher` | Médio |
| Eventos via `painel_evento_stream` | Substituir `totem_evento` inserts | Médio |

### Prioridade 3 (Médio)

| Ação | Detalhe | Esforço |
|---|---|---|
| Criar `sp_executor_painel_registrar_evento` | Event stream canônico | Baixo |
| Migrar `totem_feedback` para `painel_consumo_evento` | Unificar modelos | Médio |

---

## 5. Critério de Aceite

- [ ] Dispatcher aceita eventos genéricos sem conhecer Tipos de Painel
- [ ] Todas as SPs display seguem padrão `sp_executor_*`
- [ ] `permissao.nome_procedure` populada para todos os executors
- [ ] Eventos fluem pelo `painel_evento_stream` canônico
- [ ] Código backend não contém condicionais por tipo de painel
- [ ] Totem funciona exclusivamente via Dispatcher unificado

---

## 6. Referências

- ADR-007 — Arquitetura de Painéis/Displays
- MD-125 — Enterprise Display Architecture
- MD-134 — Display Event Distribution Engine
- `backend/src/core/dispatcher/DispatcherService.ts`
- `backend/src/core/totem/TotemService.ts`
- `database/dump/Dump20260804.sql` (linhas 14579, 11127, 11157, 15537, 25756)