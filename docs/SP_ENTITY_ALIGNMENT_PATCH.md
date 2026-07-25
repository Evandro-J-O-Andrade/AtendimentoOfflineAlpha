# SP Entity Alignment Patch

**Data:** 2026-07-25  
**Status:** ✅ Todos os patches aplicados e validados  
**Objetivo:** Alinhar SPs ao schema canônico do banco  
**Regra:** Alterar somente referências `id_saas_entidade` → `id_entidade` em tabelas de domínio/evento  

---

## Lei de Identidade de Persistência (futura)

```
id_saas_entidade:
utilizado para contexto de plataforma/runtime.

id_entidade:
utilizado para registros pertencentes ao domínio operacional.
```

---

## SPs Afetadas

| Ordem | SP | Tabelas de destino | Status |
|-------|----|--------------------|--------|
| 1 | `sp_master_registrar_evento` | `atendimento_evento` | ✅ Aplicado |
| 2 | `sp_master_assistencial_salvar_orquestradora` | `atendimento_triagem`, `atendimento_evolucao`, `atendimento_anamnese`, `atendimento_evento` | ✅ Aplicado |
| 3 | `sp_orquestrador_assistencial` | `atendimento_evento` | ✅ Aplicado |
| 4 | `sp_execucao_assistencial` | `atendimento_evento` | ✅ Aplicado |
| 5 | `sp_executor_assistencial_atendimento_finalizar` | `atendimento_evolucao`, `atendimento_diagnostico` | ✅ Aplicado |

---

## Patch 1 — `sp_master_registrar_evento`

**Tabela:** `atendimento_evento`  
**Alteração:** `id_saas_entidade` → `id_entidade`  

### Antes

```sql
INSERT INTO atendimento_evento (
    id_saas_entidade,  -- ❌ COLUNA INEXISTENTE
    id_unidade,
    id_ffa,
    id_atendimento,
    id_paciente,
    dominio,
    tipo_evento,
    estado_origem,
    estado_destino,
    contexto_fluxo,
    payload,
    id_sessao_usuario,
    id_usuario,
    hash_evento,
    criado_em
) VALUES (
    v_id_saas,  -- ❌ valor de id_saas_entidade
    v_id_unidade,
    p_id_referencia,
    v_id_atendimento,
    v_id_paciente,
    UPPER(p_dominio),
    UPPER(p_acao),
    v_estado_origem,
    v_estado_destino,
    v_estado_destino,
    p_payload,
    p_id_sessao,
    v_id_usuario,
    v_hash_evento,
    NOW(6)
);
```

### Depois

```sql
INSERT INTO atendimento_evento (
    id_entidade,  -- ✅ COLUNA CORRETA
    id_unidade,
    id_ffa,
    id_atendimento,
    id_paciente,
    dominio,
    tipo_evento,
    estado_origem,
    estado_destino,
    contexto_fluxo,
    payload,
    id_sessao_usuario,
    id_usuario,
    hash_evento,
    criado_em
) VALUES (
    v_id_saas,  -- ✅ mesmo valor, coluna correta
    v_id_unidade,
    p_id_referencia,
    v_id_atendimento,
    v_id_paciente,
    UPPER(p_dominio),
    UPPER(p_acao),
    v_estado_origem,
    v_estado_destino,
    v_estado_destino,
    p_payload,
    p_id_sessao,
    v_id_usuario,
    v_hash_evento,
    NOW(6)
);
```

**Impacto:** Desbloqueia todo o fluxo do Dispatcher.  
**Risco:** Baixo. Apenas renomeação de coluna no INSERT.

---

## Patch 2 — `sp_master_assistencial_salvar_orquestradora`

**Tabela:** `atendimento_evento`  
**Alteração:** `id_saas_entidade` → `id_entidade`  

### Antes

```sql
INSERT INTO atendimento_evento (
    id_saas_entidade,  -- ❌
    id_unidade,
    id_ffa,
    id_usuario, 
    tipo_evento, descricao, payload_snapshot, fluxo_apos
) VALUES (
    @v_saas,  -- ❌
    @v_unidade,
    @v_ffa,
    @v_user,
    p_acao, CONCAT('Registro em ', v_tabela_alvo),
    p_payload, v_novo_fluxo
);
```

### Depois

```sql
INSERT INTO atendimento_evento (
    id_entidade,  -- ✅
    id_unidade,
    id_ffa,
    id_usuario, 
    tipo_evento, descricao, payload_snapshot, fluxo_apos
) VALUES (
    @v_saas,  -- ✅
    @v_unidade,
    @v_ffa,
    @v_user,
    p_acao, CONCAT('Registro em ', v_tabela_alvo),
    p_payload, v_novo_fluxo
);
```

**Impacto:** Corrige orquestração assistencial.  
**Risco:** Baixo.

---

## Patch 3 — `sp_orquestrador_assistencial`

**Tabela:** `atendimento_evento`  
**Alteração:** `id_saas_entidade` → `id_entidade`  

### Antes

```sql
INSERT INTO atendimento_evento (
    id_saas_entidade,  -- ❌
    id_ffa,
    tipo_evento,
    contexto_fluxo,
    payload,
    id_sessao_usuario
)
SELECT
    p_id_saas_entidade,  -- ❌
    id_ffa,
    p_acao,
    contexto_fluxo,
    p_payload,
    p_id_sessao_usuario
FROM senha
WHERE id_senha = p_id_senha;
```

### Depois

```sql
INSERT INTO atendimento_evento (
    id_entidade,  -- ✅
    id_ffa,
    tipo_evento,
    contexto_fluxo,
    payload,
    id_sessao_usuario
)
SELECT
    p_id_saas_entidade,  -- ✅ mesmo valor, coluna correta
    id_ffa,
    p_acao,
    contexto_fluxo,
    p_payload,
    p_id_sessao_usuario
FROM senha
WHERE id_senha = p_id_senha;
```

**Impacto:** Corrige orquestrador de assistencial.  
**Risco:** Baixo.

---

## Patch 4 — `sp_execucao_assistencial`

**Tabela:** `atendimento_evento`  
**Alteração:** `id_saas_entidade` → `id_entidade`  

### Antes

```sql
INSERT INTO atendimento_evento (
    id_saas_entidade,  -- ❌
    id_ffa,
    tipo_evento,
    contexto_fluxo,
    payload,
    id_sessao_usuario
)
SELECT
    p_id_saas_entidade,  -- ❌
    id_ffa,
    'EXECUCAO_ASSISTENCIAL',
    contexto_fluxo,
    p_payload,
    p_id_sessao_usuario
FROM senha
WHERE id_senha = p_id_senha;
```

### Depois

```sql
INSERT INTO atendimento_evento (
    id_entidade,  -- ✅
    id_ffa,
    tipo_evento,
    contexto_fluxo,
    payload,
    id_sessao_usuario
)
SELECT
    p_id_saas_entidade,  -- ✅
    id_ffa,
    'EXECUCAO_ASSISTENCIAL',
    contexto_fluxo,
    p_payload,
    p_id_sessao_usuario
FROM senha
WHERE id_senha = p_id_senha;
```

**Impacto:** Corrige executor assistencial.  
**Risco:** Baixo.

---

## Patch 5 — `sp_executor_assistencial_atendimento_finalizar`

**Tabelas:** `atendimento_evolucao`, `atendimento_diagnostico`  
**Alteração:** `id_saas_entidade` → `id_entidade`  

### Antes

```sql
INSERT INTO atendimento_evolucao (
    id_saas_entidade,  -- ❌
    id_unidade,
    id_ffa,
    id_atendimento,
    id_usuario,
    id_sessao_usuario,
    tipo_profissional,
    texto_evolucao,
    ip_origem,
    device_info,
    criado_em
) VALUES (
    v_id_saas,  -- ❌
    ...
);

INSERT INTO atendimento_diagnostico (
    id_saas_entidade,  -- ❌
    id_unidade,
    id_ffa,
    id_usuario,
    id_sessao_usuario,
    codigo_cid,
    principal,
    ip_origem,
    device_info,
    criado_em
) VALUES (
    v_id_saas,  -- ❌
    ...
);
```

### Depois

```sql
INSERT INTO atendimento_evolucao (
    id_entidade,  -- ✅
    id_unidade,
    id_ffa,
    id_atendimento,
    id_usuario,
    id_sessao_usuario,
    tipo_profissional,
    texto_evolucao,
    ip_origem,
    device_info,
    criado_em
) VALUES (
    v_id_saas,  -- ✅ mesmo valor, coluna correta
    ...
);

INSERT INTO atendimento_diagnostico (
    id_entidade,  -- ✅
    id_unidade,
    id_ffa,
    id_usuario,
    id_sessao_usuario,
    codigo_cid,
    principal,
    ip_origem,
    device_info,
    criado_em
) VALUES (
    v_id_saas,  -- ✅
    ...
);
```

**Impacto:** Corrige executor assistencial de finalização.  
**Risco:** Baixo.

---

## Ordem de Aplicação

1. `sp_master_registrar_evento` — bloqueia todo o Dispatcher ✅ APLICADO
2. `sp_master_assistencial_salvar_orquestradora` — master assistencial ✅ APLICADO
3. `sp_orquestrador_assistencial` — orquestrador assistencial ✅ APLICADO
4. `sp_execucao_assistencial` — executor assistencial ✅ APLICADO
5. `sp_executor_assistencial_atendimento_finalizar` — executor de domínio ✅ APLICADO

---

## Validação Posterior

Após aplicar cada patch:

1. Re-executar Smoke Test 1
2. Confirmar que `sp_master_dispatcher` chega até o executor
3. Confirmar que eventos/registros são criados com `id_entidade`
4. Apenas então aplicar próximo patch

---

## Documentos Relacionados

- `docs/DATABASE_SCHEMA_ALIGNMENT_REPORT.md`
- `docs/SP_REGISTRAR_EVENTO_IMPACT_ANALYSIS.md`
- `docs/DISPATCHER_VALIDATION_RESULT.md`

---

**Fim do documento.**
