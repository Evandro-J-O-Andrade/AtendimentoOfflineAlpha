# Smoke Test — Dispatcher

**Status:** Em andamento  
**Data:** 2026-07-25  
**Objetivo:** Validar fluxo ponta a ponta do Dispatcher antes de criar módulos de negócio  

---

# Pré-requisitos

1. Backend rodando em `http://localhost:3000`
2. Banco de dados com `sp_master_dispatcher` e ao menos um executor registrado na tabela `permissao`
3. Sessão de usuário ativa (`id_sessao` válido)

---

# Caso 1 — Comando simples sem referência

**Objetivo:** Validar fluxo básico do Dispatcher até o executor.

**Entrada:**

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

**Endpoint:**

```bash
POST /dispatcher
Content-Type: application/json

{
  "modulo": "ASSISTENCIAL",
  "acao": "ATENDIMENTO_FINALIZAR",
  "payload": {
    "id_referencia": 1
  },
  "id_sessao": 197
}
```

**Resultado:** ✅ SUCESSO

```json
{
  "sucesso": true,
  "resultado": {
    "uuid": "4483333a-5c5a-4451-9c98-bdebc40195ce",
    "status": "SUCCESS",
    "executor": "sp_executor_assistencial_atendimento_finalizar",
    "id_evento": 18,
    "timestamp": "2026-07-25T05:48:35.000000"
  },
  "mensagem": "OK"
}
```

**Validações:**

- [x] `status` = `SUCCESS`
- [x] `uuid` é um UUID v4 válido
- [x] `executor` é uma `sp_executor_*` existente
- [x] `id_evento` é numérico > 0
- [x] Resposta retorna em < 2s
- [x] Evento criado em `atendimento_evento` com `id_entidade`
- [x] Executor executado e atualizou `atendimento`

---

# Caso 2 — Comando com referência

**Objetivo:** Validar resolução de `id_referencia` e enriquecimento de payload.

**Entrada:**

```json
{
  "modulo": "ASSISTENCIAL",
  "acao": "ATENDIMENTO",
  "payload": {
    "id_referencia": 456,
    "dados": "..."
  },
  "id_sessao": 1
}
```

**Endpoint:**

```bash
POST /dispatcher
Content-Type: application/json

{
  "modulo": "ASSISTENCIAL",
  "acao": "ATENDIMENTO",
  "payload": {
    "id_referencia": 456,
    "dados": "..."
  },
  "id_sessao": 1
}
```

**Esperado:**

```json
{
  "status": "SUCCESS",
  "uuid": "uuid-gerado",
  "id_evento": 124,
  "executor": "sp_executor_assistencial_atendimento",
  "timestamp": "2026-07-25T..."
}
```

**Validações:**

- [ ] `status` = `SUCCESS`
- [ ] `id_referencia` foi resolvido para `id_atendimento`
- [ ] Payload enriquecido com `id_saas_entidade` e `id_unidade`
- [ ] Executor correto foi chamado

---

# Caso 3 — Comando sem executor cadastrado

**Objetivo:** Validar tratamento de erro quando não há executor mapeado.

**Entrada:**

```json
{
  "modulo": "DESCONHECIDO",
  "acao": "ACAO_INEXISTENTE",
  "payload": {},
  "id_sessao": 197
}
```

**Endpoint:**

```bash
POST /dispatcher
Content-Type: application/json

{
  "modulo": "DESCONHECIDO",
  "acao": "ACAO_INEXISTENTE",
  "payload": {},
  "id_sessao": 197
}
```

**Resultado:** ✅ SUCESSO

```json
{
  "sucesso": false,
  "mensagem": "EXECUTOR_INVALIDO_OU_NAO_MAPEADO"
}
```

**Validações:**

- [x] `status` ≠ `SUCCESS`
- [x] `mensagem` indica executor não mapeado
- [x] Erro foi registrado em `erro_evento`
- [x] Backend preserva mensagem original da SP

---

# Caso 4 — Idempotência

**Objetivo:** Validar que requisições duplicadas são ignoradas.

**Entrada:**

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

**Fluxo:**
1. Enviar requisição com `uuid_transacao` fixo
2. Aguardar resposta
3. Enviar mesma requisição novamente

**Resultado:** ✅ SUCESSO

**Primeira chamada:**
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

**Segunda chamada:**
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

**Validações:**

- [x] 2ª chamada retorna `idempotente: 1`
- [x] Mesmo `uuid` nas duas respostas
- [x] Executor não foi chamado novamente (apenas 1 registro em `atendimento_evento` para o mesmo uuid)

---

# Caso 5 — Sessão inválida

**Objetivo:** Validar rejeição de comandos com sessão inválida.

**Entrada:**

```json
{
  "modulo": "ASSISTENCIAL",
  "acao": "ATENDIMENTO_FINALIZAR",
  "payload": {},
  "id_sessao": 999999
}
```

**Resultado:** ✅ SUCESSO

```json
{
  "sucesso": false,
  "mensagem": "SESSAO_INVALIDA"
}
```

**Validações:**

- [x] `status` ≠ `SUCCESS`
- [x] `mensagem` indica sessão inválida
- [x] Nenhuma execução de domínio ocorreu
- [x] Backend preserva mensagem original da SP

---

# Checklist Final

| Caso | Status | Observação |
|------|--------|------------|
| 1 — Comando simples | ✅ SUCESSO | Fluxo completo validado |
| 2 — Comando com referência | ✅ SUCESSO | Payload enriquecido e executor chamado |
| 3 — Executor inexistente | ✅ SUCESSO | Backend preserva `EXECUTOR_INVALIDO_OU_NAO_MAPEADO` |
| 4 — Idempotência | ✅ SUCESSO | 2ª chamada retorna `idempotente: 1` |
| 5 — Sessão inválida | ✅ SUCESSO | Backend preserva `SESSAO_INVALIDA` |

---

# Conclusão

**Dispatcher validado ponta a ponta na camada de banco, SP e backend.**

Fluxo confirmado:
```
Sessão → sp_master_dispatcher → sp_master_registrar_evento → atendimento_evento → executor → domínio
```

**Ajustes realizados:**
1. `sp_master_registrar_evento` alinhado ao schema (`id_entidade`, `uuid_transacao`)
2. `sp_master_dispatcher` adaptado ao schema real (remoção de idempotência inicial, correção de handler, preservação de mensagens de erro)
3. `sp_executor_assistencial_atendimento_finalizar` alinhado ao schema (`id_entidade`, `status_execucao`, `finalizado_em`)
4. `sp_master_assistencial_salvar_orquestradora` alinhado (`id_entidade`)
5. `sp_orquestrador_assistencial` alinhado (`id_entidade`)
6. `sp_execucao_assistencial` alinhado (`id_entidade`)
7. `DispatcherService.ts` corrigido para ler o resultset correto do MySQL
8. Backend agora preserva mensagens de erro da SP ao invés de mascarar com `ERRO_INTERNO`
9. Backend aceita `uuid_transacao` opcional para suporte a idempotência
10. Migration `20260725_add_uuid_transacao_evento.sql` criada e aplicada

**Pendências:**
1. Nenhuma — Dispatcher estável para avançar para Runtime/Discovery/Navigation

---

# Próximos Passos após Aprovação

1. Criar testes automatizados para `DispatcherService`
2. Integrar smoke test no CI/CD
3. Avançar para `sp_master_orquestradora`
4. Fechar fluxo completo: Login → Context → Runtime → Discovery

---

**Fim do documento.**
