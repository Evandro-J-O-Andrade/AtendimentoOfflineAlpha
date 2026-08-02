# MD-TOTEM-003 — Executor Mapping

## Status
Documento Canônico de Domínio.
Define o mapeamento de executores do domínio Totem.

---

## Classificação
```text
Tipo: Domain Execution
Camada: Kernel / Executor
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Propósito

Mapear os executores do domínio Totem, definindo como cada capability é executada pela espinha dorsal canônica.

---

## Princípio fundamental

```text
Executor é a única camada que executa ação.
Executor não decide regra.
Executor chama SP canônica.
Executor retorna resultado padronizado.
```

---

## Mapa de executores

### totem.opcoes_get

**Capability:** `TOTEM_OPCOES_READ`  
**Tipo:** QUERY  
**SP:** `sp_totem_opcoes_get` (a criar) ou query direta em `totem_senha_opcao`  
**Input:** `id_unidade`, `id_local_operacional`  
**Output:** Array de `TotemOpcao`  
**Contexto:** Sessão + Unidade + Local  
**Autorização:** `TOTEM_OPCOES_READ`  

**Fluxo:**
```text
Executor recebe request
    ↓
Valida sessão
    ↓
Valida permissão TOTEM_OPCOES_READ
    ↓
Consulta totem_senha_opcao
    ↓
Retorna array de opções
```

---

### totem.plantao_medico_get

**Capability:** `TOTEM_PLANTAO_READ`  
**Tipo:** QUERY  
**SP:** A definir (consumir fonte canônica de escala)  
**Input:** `id_unidade`, `data`  
**Output:** Array de `TotemPlantaoItem`  
**Contexto:** Sessão + Unidade  
**Autorização:** `TOTEM_PLANTAO_READ`  

**Fluxo:**
```text
Executor recebe request
    ↓
Valida sessão
    ↓
Valida permissão TOTEM_PLANTAO_READ
    ↓
Consulta escala médica canônica
    ↓
Retorna array de plantão
```

**Observação:** Totem não administra escala. Apenas consome a fonte canônica.

---

### totem.gerar_senha

**Capability:** `TOTEM_SENHA_GERAR`  
**Tipo:** COMMAND  
**SP:** `sp_totem_gerar_senha`  
**Input:** `id_opcao`, `id_unidade`, `id_local_operacional`, `id_paciente`  
**Output:** `TotemSenhaResponse`  
**Contexto:** Sessão + Unidade + Local  
**Autorização:** `TOTEM_SENHA_GERAR`  
**Auditoria:** Obrigatória  
**Ledger:** `GERAR_SENHA`  

**Fluxo:**
```text
Executor recebe request
    ↓
Valida sessão
    ↓
Valida permissão TOTEM_SENHA_GERAR
    ↓
Valida opção em totem_senha_opcao
    ↓
Chama sp_totem_gerar_senha
    ↓
Registra totem_evento (SENHA_GERADA)
    ↓
Registra ledger_evento_log
    ↓
Retorna TotemSenhaResponse
```

---

### totem.feedback_get

**Capability:** `TOTEM_FEEDBACK_READ`  
**Tipo:** QUERY  
**SP:** Query direta em `totem_feedback`  
**Input:** `id_senha` (opcional)  
**Output:** Array de feedbacks  
**Contexto:** Sessão  
**Autorização:** `TOTEM_FEEDBACK_READ`  

**Fluxo:**
```text
Executor recebe request
    ↓
Valida sessão
    ↓
Valida permissão TOTEM_FEEDBACK_READ
    ↓
Consulta totem_feedback
    ↓
Retorna array de feedbacks
```

---

### totem.feedback_create

**Capability:** `TOTEM_FEEDBACK_CREATE`  
**Tipo:** COMMAND  
**SP:** Query direta em `totem_feedback`  
**Input:** `id_senha`, `origem`, `nota`, `comentario`  
**Output:** `TotemFeedbackResponse`  
**Contexto:** Sessão + Senha  
**Autorização:** `TOTEM_FEEDBACK_CREATE`  
**Auditoria:** Obrigatória  
**Ledger:** `FEEDBACK_CRIADO`  

**Fluxo:**
```text
Executor recebe request
    ↓
Valida sessão
    ↓
Valida permissão TOTEM_FEEDBACK_CREATE
    ↓
Valida senha existe
    ↓
Insere totem_feedback
    ↓
Registra ledger_evento_log
    ↓
Retorna TotemFeedbackResponse
```

---

## Regras de execução

1. Todo executor valida sessão antes de qualquer ação
2. Todo executor valida permissão via capability
3. Todo COMMAND registra auditoria no ledger
4. Todo executor retorna contrato padronizado
5. Erros são tratados e nunca silenciosos

---

## Referências

- `MD-TOTEM-000` — Conceito do domínio
- `MD-TOTEM-001` — Contrato API
- `MD-TOTEM-002` — Capability Registry
- `CORE-004-PERMISSION-RUNTIME.md` — Permission Runtime
