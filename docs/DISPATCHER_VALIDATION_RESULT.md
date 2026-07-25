# Dispatcher Validation Result

**Data:** 2026-07-25  
**Status:** 🟢 Dispatcher validado — Kernel/Runtime estável  
**Ambiente:** Backend porta 3001, banco real alinhado com SPs  

---

## Testes Executados

| Teste | Resultado | Evidência |
|-------|-----------|-----------|
| 1 — Comando simples | ✅ SUCESSO | Fluxo completo: sessão → evento → executor → domínio |
| 2 — Comando com referência | ✅ SUCESSO | Payload enriquecido, executor chamado com sucesso |
| 3 — Executor inexistente | ✅ SUCESSO | Backend retorna `EXECUTOR_INVALIDO_OU_NAO_MAPEADO` |
| 4 — Idempotência | ✅ SUCESSO | 2ª chamada retorna `idempotente: 1` |
| 5 — Sessão inválida | ✅ SUCESSO | Backend retorna `SESSAO_INVALIDA` |

---

## Evidência do Teste 1

**Request:**
```json
{
  "modulo": "ASSISTENCIAL",
  "acao": "ATENDIMENTO_FINALIZAR",
  "payload": {
    "id_referencia": 1
  },
  "id_sessao": 197
}
```

**Response:**
```json
{
  "sucesso": true,
  "resultado": {
    "uuid": "23778297-9276-492f-9358-bafee6d1d81a",
    "status": "SUCCESS",
    "executor": "sp_executor_assistencial_atendimento_finalizar",
    "id_evento": 23,
    "timestamp": "2026-07-25T06:18:19.000000"
  },
  "mensagem": "OK"
}
```

---

## Evidência do Teste 4 — Idempotência

**Request (1ª chamada):**
```json
{
  "modulo": "ASSISTENCIAL",
  "acao": "ATENDIMENTO_FINALIZAR",
  "payload": {
    "id_referencia": 1
  },
  "id_sessao": 197,
  "uuid_transacao": "test-idempotency-789"
}
```

**Response (1ª chamada):**
```json
{
  "sucesso": true,
  "resultado": {
    "uuid": "test-idempotency-789",
    "status": "SUCCESS",
    "executor": "sp_executor_assistencial_atendimento_finalizar",
    "id_evento": 28,
    "timestamp": "2026-07-25T06:23:54.000000"
  },
  "mensagem": "OK"
}
```

**Response (2ª chamada):**
```json
{
  "sucesso": true,
  "resultado": {
    "uuid": "test-idempotency-789",
    "status": "SUCCESS",
    "idempotente": 1
  },
  "mensagem": "OK"
}
```

---

## Problemas Encontrados e Corrigidos

### 1. Divergência: `sp_master_registrar_evento` vs tabela `atendimento_evento`
- **Status:** ✅ Corrigido
- **Ação:** Alterada SP para usar `id_entidade` e `uuid_transacao`

### 2. Divergência: `sp_master_dispatcher` vs tabela `sessao_usuario`
- **Status:** ✅ Corrigido
- **Ação:** Alterada SP para usar `id_entidade` ao invés de `id_saas_entidade` e removida referência a `id_painel`

### 3. Divergência: `sp_master_dispatcher` vs tabela `erro_evento`
- **Status:** ✅ Corrigido
- **Ação:** Alterada SP para usar colunas existentes

### 4. Divergência: `sp_master_assistencial_salvar_orquestradora` vs tabelas de domínio
- **Status:** ✅ Corrigido
- **Ação:** Alterada SP para usar `id_entidade` em `atendimento_triagem`, `atendimento_evolucao`, `atendimento_anamnese` e `atendimento_evento`

### 5. Divergência: `sp_orquestrador_assistencial` vs tabela `atendimento_evento`
- **Status:** ✅ Corrigido
- **Ação:** Alterada SP para usar `id_entidade`

### 6. Divergência: `sp_execucao_assistencial` vs tabela `atendimento_evento`
- **Status:** ✅ Corrigido
- **Ação:** Alterada SP para usar `id_entidade`

### 7. Divergência: `sp_executor_assistencial_atendimento_finalizar` vs tabelas de domínio
- **Status:** ✅ Corrigido
- **Ação:** 
  - `atendimento_evolucao`: alterado para `id_entidade`
  - `atendimento_diagnostico`: removidas colunas inexistentes
  - `atendimento`: alterado para `status_execucao = 'CONCLUIDO'` e `finalizado_em`

### 8. Backend: leitura de resultset do MySQL
- **Status:** ✅ Corrigido
- **Ação:** `DispatcherService.ts` ajustado para ler o penúltimo resultset

### 9. Backend: mascaramento de erros da SP
- **Status:** ✅ Corrigido
- **Ação:** Backend agora captura `error.sqlMessage` e retorna a mensagem original da SP

### 10. Backend: suporte a idempotência
- **Status:** ✅ Corrigido
- **Ação:** Backend aceita `uuid_transacao` opcional e SP verifica duplicidade antes de executar

### 11. Migration: coluna `uuid_transacao` ausente em `atendimento_evento`
- **Status:** ✅ Criada e aplicada
- **Arquivo:** `database/migrations/20260725_add_uuid_transacao_evento.sql`

---

## Classificação

🟢 **Validado — Kernel/Runtime estável**

**O que funcionou:**
- Backend sobe corretamente na porta 3001
- Rota `/dispatcher/` responde
- `DispatcherService` gera UUID, normaliza domínio/acao, extrai referencia
- Chamada SQL é montada corretamente com 6 parâmetros
- `sp_master_dispatcher` executa fluxo completo: valida sessão → registra evento → chama executor
- `atendimento_evento` recebe registro com `id_entidade` e `uuid_transacao`
- Executor executado e atualizou `atendimento` e `atendimento_evolucao`
- Erros de negócio são propagados corretamente ao frontend
- Idempotência funciona: 2ª chamada com mesmo `uuid_transacao` retorna `idempotente: 1`

---

## Próximos Passos

1. **Avançar para Runtime/Discovery/Navigation validation**
2. **Criar primeiro container de domínio (Portal Runtime ou Atendimento)**

---

## Documentos Relacionados

- `docs/SP_ENTITY_ALIGNMENT_PATCH.md`
- `docs/DISPATCHER_SMOKE_TEST.md`
- `docs/DATABASE_SCHEMA_ALIGNMENT_REPORT.md`
- `database/migrations/20260725_add_uuid_transacao_evento.sql`

---

**Fim do documento.**
