# Auditoria Master SP Architecture

**Status:** Em andamento  
**Data:** 2026-07-25  
**Objetivo:** Mapear a arquitetura real das Stored Procedures mestres e validar conformidade com MD-000  

---

# Ordem de Auditoria

1. `MD-000-Constituicao-Arquitetural.md` — Fonte de verdade arquitetural
2. `MYSQLBANCO.md` — Especificação do banco
3. `database/dump/Dump20260618.sql` — Implementação SQL
4. `backend/src/` — Implementação backend
5. `packages/` — Implementação frontend

---

# SPs Mestres Identificadas no Banco

## Orquestradores

| SP | Assinatura | Função | Chamada no Backend |
|----|-----------|--------|-------------------|
| `sp_master_orquestradora` | `(p_id_sessao, p_modulo, p_acao, p_payload)` | Orquestrador de alto nível. Dispatch por módulo. | ❌ **NÃO CHAMADA** |
| `sp_master_dispatcher` | `(p_id_sessao, p_uuid_transacao, p_dominio, p_acao, p_id_referencia, p_payload)` | Dispatcher de baixo nível. Resolve executor na tabela `permissao`. | ⚠️ Chamada com assinatura ERRADA |

## SPs Mestres por Domínio

| SP | Domínio | Assinatura |
|----|---------|-----------|
| `sp_master_login` | Auth | `(p_acao, p_payload, OUT p_resultado, OUT p_sucesso, OUT p_mensagem)` |
| `sp_master_assistencial` | Assistencial | Chama executores específicos |
| `sp_master_estoque` | Estoque | Chama executores específicos |
| `sp_master_faturamento` | Faturamento | Chama executores específicos |
| `sp_master_query_dispatcher` | Queries | Resolve queries por domínio |
| `sp_master_paciente` | Paciente | `(p_id_sessao, p_id_usuario, p_payload, OUT p_resultado)` |
| `sp_master_ffa_movimentar` | Workflow | `(p_id_sessao, p_id_usuario, p_id_ffa, p_novo_status, OUT p_resultado)` |

## SPs de Infraestrutura

| SP | Função |
|----|--------|
| `sp_master_registrar_evento` | Ledger de eventos |
| `sp_master_registrar_alerta` | Alertas |
| `sp_master_registrar_erro` | Log de erros |
| `sp_master_routes` | Rotas/navegação |
| `sp_sessao_assert` | Validação de sessão |

---

# Inconsistência Crítica: Backend vs Banco

## Assinatura Errada

**O backend chama `sp_master_dispatcher` com assinatura diferente da definida no banco:**

```javascript
// DispatcherService.ts (backend)
'CALL sp_master_dispatcher(?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)',
[request.modulo, request.acao, JSON.stringify(request.payload), request.id_sessao]
```

**Mas a SP no banco espera:**

```sql
CREATE PROCEDURE `sp_master_dispatcher`(
    IN p_id_sessao BIGINT,
    IN p_uuid_transacao CHAR(36),
    IN p_dominio VARCHAR(50),
    IN p_acao VARCHAR(100),
    IN p_id_referencia BIGINT,
    IN p_payload JSON
)
```

### Mapeamento

| Parâmetro SP | Valor do Backend | Esperado | Recebido | Status |
|-------------|------------------|----------|----------|--------|
| `p_id_sessao` | `request.modulo` (string) | BIGINT | STRING | 🔴 ERRO |
| `p_uuid_transacao` | `request.acao` (string) | CHAR(36) | STRING | 🔴 ERRO |
| `p_dominio` | `JSON.stringify(request.payload)` | VARCHAR(50) | JSON STRING | 🔴 ERRO |
| `p_acao` | `request.id_sessao` (number) | VARCHAR(100) | NUMBER | 🔴 ERRO |
| `p_id_referencia` | `@p_resultado` (OUT) | BIGINT | VARIÁVEL OUT | 🔴 ERRO |
| `p_payload` | `@p_sucesso` (OUT) | JSON | VARIÁVEL OUT | 🔴 ERRO |

**Faltam:** `p_uuid_transacao` (CHAR), `@p_mensagem` (OUT)

**Classificação:** 🚨 BUG CRÍTICO

---

# SPs de Executores (Tabela permissao)

A `sp_master_dispatcher` resolve executores dinamicamente:

- **Código de busca:** `CONCAT(UPPER(p_dominio), '.', UPPER(p_acao))`
- **Filtro:** `nome_procedure LIKE 'sp_executor_%'`
- **Execução:** Dinâmica via `PREPARE`/`EXECUTE`

Exemplos esperados:
- `ASSISTENCIAL.ATENDIMENTO` → `sp_executor_assistencial_atendimento`
- `ESTOQUE.MOVIMENTAR` → `sp_executor_estoque_movimentar`
- `FATURAMENTO.FATURAR` → `sp_executor_faturamento_faturar`

---

# Validação Arquitetural

## MD-000 — Dispatcher First

**Princípio:** "Todo comando entra pelo Dispatcher."

**Status atual:** 🔴 DIVERGENTE

**Evidência:**
- Backend tem 14 endpoints bypassando o Dispatcher
- Apenas 1 endpoint (`POST /dispatcher`) usa o Dispatcher
- `sp_master_orquestradora` existe no banco mas não é chamada

**Recomendação:** Unificar backend via Dispatcher/Orchestrator.

---

## MD-000 — SP-First

**Princípio:** "Toda regra de negócio deve ser executada por Stored Procedures."

**Status atual:** 🟡 PARCIAL

**Evidência:**
- Backend tem SELECT direto em `AuthService.authenticate()`
- Backend usa bcrypt + JWT no service layer
- Banco tem SPs mestres bem estruturadas

**Recomendação:** Migrar lógica de auth para `sp_master_login`.

---

## MD-000 — Frontend Declarativo

**Princípio:** "O React é um cliente operacional. Ele envia comandos. Ele nunca decide regras de negócio."

**Status atual:** 🟡 PARCIAL

**Evidência:**
- Frontend tem `DOMAIN_REGISTRY` hardcoded (já removido)
- Frontend chama endpoints específicos (`/auth/*`, `/portal/*`)
- Frontend usa `fetch` direto em `ContextSelectionPage` (já corrigido)

**Recomendação:** Migrar para Dispatcher Client.

---

# Fluxo Oficial Esperado vs Real

## Esperado (MD-000)

```
React
 ↓
API
 ↓
sp_master_dispatcher
 ↓
sp_master_orquestradora
 ↓
sp_executor_*
 ↓
Domínio
 ↓
Evento
 ↓
Estado
 ↓
Resposta
 ↓
React
```

## Real (Backend Atual)

```
React
 ↓
API
 ↓
/auth/* → sp_master_login (direto)
 /portal/* → sp_auth_menu_get (direto)
 /dispatcher → sp_master_dispatcher (assinatura errada)
```

---

# Classificação de Status

| Status | Significado |
|--------|-------------|
| ✅ Conforme | Implementação alinhada com MD-000 |
| 🟡 Parcial | Implementação parcial,需要 ajustes |
| 🔴 Divergente | Implementação contraria MD-000 |
| ⚪ Não materializado | Arquitetura definida mas não implementada |

---

# Próximos Passos

1. Corrigir assinatura de `sp_master_dispatcher` no backend
2. Implementar rota `/orchestrator` no backend
3. Unificar backend via Dispatcher/Orchestrator
4. Migrar frontend para Dispatcher Client
5. Atualizar TRACEABILITY_MAP com status classificados

---

**Fim do documento.**
