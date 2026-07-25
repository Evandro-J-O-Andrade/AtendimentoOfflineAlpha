# Análise de Contrato — Dispatcher

**Status:** Proposta  
**Data:** 2026-07-25  
**Referência:** MD-000 — Constituição Arquitetural  

---

# Objetivo

Definir o contrato oficial entre as camadas Backend e Banco para o Dispatcher, antes de qualquer alteração de código.

---

# Entradas

## 1. Frontend / API (contrato público atual)

Campos enviados pelo frontend via `DispatcherRequest`:

| Campo | Tipo | Origem | Descrição |
|-------|------|--------|-----------|
| `modulo` | `string` | Frontend | Módulo alvo (ex: `LOGIN`, `ASSISTENCIAL`) |
| `acao` | `string` | Frontend | Ação específica (ex: `AUTENTICAR`, `LISTAR`) |
| `payload` | `Record<string, unknown>` | Frontend | Dados do comando |
| `id_sessao` | `number` | AuthProvider | Sessão do usuário |

**Arquivo:** `backend/src/core/dispatcher/DispatcherService.ts`

```typescript
export interface DispatcherRequest {
  modulo: string
  acao: string
  payload: Record<string, unknown>
  id_sessao: number
}
```

**Chamada atual:**

```javascript
'CALL sp_master_dispatcher(?, ?, ?, ?, @p_resultado, @p_sucesso, @p_mensagem)',
[request.modulo, request.acao, JSON.stringify(request.payload), request.id_sessao]
```

---

## 2. Banco (contrato interno atual)

Stored Procedure: `sp_master_dispatcher`

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

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `p_id_sessao` | `BIGINT` | ID da sessão do usuário |
| `p_uuid_transacao` | `CHAR(36)` | UUID da transação (idempotência) |
| `p_dominio` | `VARCHAR(50)` | Domínio alvo (ex: `ASSISTENCIAL`, `ESTOQUE`) |
| `p_acao` | `VARCHAR(100)` | Ação específica |
| `p_id_referencia` | `BIGINT` | ID de referência (ex: id_atendimento) |
| `p_payload` | `JSON` | Dados do comando |

**Arquivo:** `database/dump/Dump20260618.sql` (linha 25480)

---

# Divergência Identificada

## Mapeamento atual (INCORRETO)

| Parâmetro SP | Valor do Backend | Tipo Esperado | Tipo Recebido | Status |
|-------------|------------------|---------------|---------------|--------|
| `p_id_sessao` | `request.modulo` (string) | BIGINT | STRING | 🔴 ERRO |
| `p_uuid_transacao` | `request.acao` (string) | CHAR(36) | STRING | 🔴 ERRO |
| `p_dominio` | `JSON.stringify(request.payload)` | VARCHAR(50) | JSON STRING | 🔴 ERRO |
| `p_acao` | `request.id_sessao` (number) | VARCHAR(100) | NUMBER | 🔴 ERRO |
| `p_id_referencia` | `@p_resultado` (OUT) | BIGINT | VARIÁVEL OUT | 🔴 ERRO |
| `p_payload` | `@p_sucesso` (OUT) | JSON | VARIÁVEL OUT | 🔴 ERRO |

**Faltam:** `p_uuid_transacao` (CHAR), `@p_mensagem` (OUT)

---

# Proposta de Contrato Oficial

## Princípio

O backend deve ser o **Adapter** entre o contrato público do frontend e o contrato interno do banco.

```
Frontend
    ↓
DispatcherRequest (contrato público)
    ↓
DispatcherAdapter (backend)
    ↓
sp_master_dispatcher (contrato banco)
```

---

## Contrato Público (mantido)

Manter `DispatcherRequest` como está, pois é usado pelo frontend.

```typescript
export interface DispatcherRequest {
  modulo: string      // → mapeia para dominio
  acao: string        // → mapeia para acao
  payload: Record<string, unknown>  // → mapeia para payload
  id_sessao: number   // → mapeia para id_sessao
}
```

---

## Mapeamento Adapter (backend)

| Campo Público | Campo Banco | Transformação |
|---------------|-------------|---------------|
| `modulo` | `p_dominio` | `request.modulo.toUpperCase()` |
| `acao` | `p_acao` | `request.acao.toUpperCase()` |
| `payload` | `p_payload` | `JSON.stringify(request.payload)` |
| `id_sessao` | `p_id_sessao` | `Number(request.id_sessao)` |
| — | `p_uuid_transacao` | `crypto.randomUUID()` |
| — | `p_id_referencia` | `payload.id_referencia ?? 0` |

---

## Assinatura Correta da Chamada

```sql
CALL sp_master_dispatcher(
  p_id_sessao: ?,           -- request.id_sessao
  p_uuid_transacao: ?,      -- uuid gerado
  p_dominio: ?,             -- request.modulo.toUpperCase()
  p_acao: ?,                -- request.acao.toUpperCase()
  p_id_referencia: ?,       -- payload.id_referencia ?? 0
  p_payload: ?              -- JSON.stringify(request.payload)
)
```

---

## Retorno Esperado

A SP retorna:

```sql
SELECT JSON_OBJECT(
    'status', 'SUCCESS',
    'uuid', v_uuid,
    'id_evento', v_id_evento,
    'executor', v_nome_sp,
    'timestamp', NOW()
) AS result;
```

Backend deve parsear e retornar:

```typescript
{
  status: 'SUCCESS',
  uuid: string,
  id_evento: number,
  executor: string,
  timestamp: string
}
```

---

# Decisão Pendente

## Opção A — Adapter no Backend (RECOMENDADA)

**Responsável pelo mapeamento:** `DispatcherService.ts`

**Vantagens:**
- ✅ Não quebra clientes existentes
- ✅ Mantém compatibilidade com frontend atual
- ✅ Respeita a arquitetura do banco
- ✅ Centraliza transformação em um ponto

**Desvantagens:**
- ⚠️ Backend cresce em responsabilidade

**Implementação:**
```typescript
async dispatch(request: DispatcherRequest): Promise<DispatcherResponse> {
  const dominio = request.modulo.toUpperCase()
  const acao = request.acao.toUpperCase()
  const uuid = crypto.randomUUID()
  const idReferencia = (request.payload?.id_referencia as number) ?? 0
  const payloadJson = JSON.stringify(request.payload)

  // Chamar sp_master_dispatcher com assinatura correta
  ...
}
```

---

## Opção B — Alterar a SP

**Responsável pelo mapeamento:** `sp_master_dispatcher`

**Vantagens:**
- ✅ Backend não muda
- ✅ SPs filhas recebem formato unificado

**Desvantagens:**
- ❌ Altera assinatura de SP já documentada no banco
- ❌ Pode quebrar outras integrações
- ❌ Viola SP-First (lógica de adaptação no banco)

**Não recomendado.**

---

## Opção C — Criar SP Adapter no Banco

**Responsável pelo mapeamento:** Nova SP `sp_master_api_dispatcher`

**Vantagens:**
- ✅ Isola adaptação no banco
- ✅ Permite múltiplas versões de API

**Desvantagens:**
- ❌ Aumenta complexidade
- ❌ Mais uma camada para manter
- ❌ Lógica de adaptação no banco ( Viola SP-First? )

**Não recomendado para este cenário.**

---

# Decisão

**Recomendação: Opção A — Adapter no Backend**

Motivo:
- Mantém contrato público estável
- Respeita arquitetura do banco
- Responsabilidade de adaptação é do backend (camada de transporte)
- Mais simples de implementar e testar

---

# Validações Obrigatórias Concluídas

## 1. Assinatura da SP (CONFIRMADA)

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

**Fonte:** `database/dump/Dump20260618.sql` linha 25480

**Conclusão:** 6 parâmetros IN. Nenhum parâmetro OUT.

---

## 2. Formato de Retorno (CONFIRMADO)

A SP retorna via SELECT direto:

```sql
-- Em caso de sucesso:
SELECT JSON_OBJECT(
    'status', 'SUCCESS',
    'uuid', v_uuid,
    'id_evento', v_id_evento,
    'executor', v_nome_sp,
    'timestamp', NOW()
) AS result;

-- Em caso de idempotência:
SELECT JSON_OBJECT('status','SUCCESS','idempotente',1,'uuid', v_uuid) AS result;

-- Em caso de erro:
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
```

**Conclusão:** A SP NÃO usa variáveis OUT. O retorno é um SELECT direto com alias `result`.

**Implicação para o backend:**
- NÃO deve usar `SELECT @p_resultado, @p_sucesso, @p_mensagem`
- Deve ler o resultado do SELECT direto da SP
- O backend atual está usando o mecanismo errado de retorno

---

## 3. Política de Transação (CONFIRMADA)

A SP `sp_master_dispatcher` **NÃO controla transação**.

```sql
-- NÃO existe na SP:
-- START TRANSACTION;
-- COMMIT;
-- ROLLBACK;
```

Apenas o handler global faz `ROLLBACK` em caso de erro:

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 v_msg = MESSAGE_TEXT;
    INSERT INTO erro_evento (...);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_msg;
END;
```

**Conclusão:** A transação é controlada pelo executor (`sp_executor_*`), não pelo dispatcher.

**Implicação para o backend:**
- Backend NÃO deve envolver a chamada em transação
- Deve apenas chamar a SP e retornar o resultado

---

## 4. Regra de id_referencia (CONFIRMADA)

```sql
IF p_id_referencia > 0 THEN
    SELECT id_atendimento INTO v_id_atendimento_vinculo
    FROM atendimento_vinculo 
    WHERE id_ffa = p_id_referencia AND ativo = 1 LIMIT 1;

    SET p_payload = JSON_SET(p_payload, 
        '$.id_atendimento', v_id_atendimento_vinculo,
        '$.id_saas_entidade', v_id_saas,
        '$.id_unidade', v_id_unidade
    );
END IF;
```

**Regra oficial:**

| Valor | Significado | Comportamento da SP |
|-------|-------------|---------------------|
| `0` | Sem referência | Ignora resolução de vínculo |
| `> 0` | ID de referência válido | Resolve vínculo e enriquece payload |
| `NULL` | Não informado | Ignora resolução (não entra no IF) |

**Conclusão:** 
- `0` é o valor padrão oficial para "sem referência"
- `NULL` funciona, mas `0` é mais explícito e consistente
- A SP espera `BIGINT`, não `VARCHAR`

**Implicação para o backend:**
- Usar `0` como default quando não houver referência
- NÃO usar `null`
- Documentar no contrato público se `id_referencia` é opcional ou obrigatório

---

# Impactos

## Frontend

Nenhum. Contrato `DispatcherRequest` permanece inalterado.

## Backend

- `DispatcherService.ts` — atualizar assinatura da chamada
- `DispatcherController.ts` — verificar se há validação adicional
- Testes unitários do dispatcher — atualizar mocks

## Banco

Nenhum. `sp_master_dispatcher` permanece como está.

## Integrações

Nenhuma. APIs públicas mantêm-se inalteradas.

---

# Validações Concluídas

## 1. Assinatura da SP (CONFIRMADA)

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

**Fonte:** `database/dump/Dump20260618.sql` linha 25480

---

## 2. Formato de Retorno (CONFIRMADO)

A SP retorna via SELECT direto, sem parâmetros OUT:

```sql
SELECT JSON_OBJECT(
    'status', 'SUCCESS',
    'uuid', v_uuid,
    'id_evento', v_id_evento,
    'executor', v_nome_sp,
    'timestamp', NOW()
) AS result;
```

**Conclusão:** Backend deve ler o resultado do SELECT direto, não de variáveis OUT.

---

## 3. Política de Transação (CONFIRMADA)

A SP não controla transação. Apenas o handler global faz ROLLBACK em caso de erro.

**Conclusão:** Backend não deve envolver a chamada em transação.

---

## 4. Regra de id_referencia (CONFIRMADA)

```sql
IF p_id_referencia > 0 THEN
    -- resolução de vínculo
END IF;
```

**Conclusão:** `0` é o valor "sem referência". Backend deve usar `0` como default.

---

# Próximos Passos

1. Aprovar esta análise
2. Implementar Adapter em `DispatcherService.ts`
3. Testar isoladamente com dados reais
4. Validar com `sp_master_orquestradora` (próxima fase)
5. Atualizar `MASTER_SP_ARCHITECTURE_MAP.md`

---

**Fim do documento.**
