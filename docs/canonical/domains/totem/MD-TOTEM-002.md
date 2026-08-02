# MD-TOTEM-002 — Capability Registry

## Status
Documento Canônico de Domínio.
Define as capabilities do domínio Totem no Kernel.

---

## Classificação
```text
Tipo: Domain Capability
Camada: Kernel / Registry
Prioridade: Alta
Obrigatoriedade: Global
```

---

## Propósito

Registrar as capabilities do domínio Totem no Kernel, permitindo descoberta, autorização e execução canônica.

---

## Princípio fundamental

```text
Totem não executa diretamente.
Totem declara capabilities.
Kernel valida, autoriza e executa.
```

---

## Capabilities do domínio Totem

### TOTEM_OPCOES_READ

**Descrição:** Listar opções de atendimento do totem  
**Tipo:** QUERY  
**Domínio:** TOTEM  
**Permissão requerida:** `TOTEM_OPCOES_READ`  
**Executor:** `totem.opcoes_get`  
**SP:** `sp_totem_opcoes_get` (a criar) ou query direta em `totem_senha_opcao`  
**Contexto:** `id_unidade`, `id_local_operacional`  
**Cache:** 5 minutos  

**Input:**
```json
{
  "id_unidade": 1,
  "id_local_operacional": 1
}
```

**Output:**
```json
{
  "opcoes": []
}
```

---

### TOTEM_PLANTAO_READ

**Descrição:** Listar plantão médico do dia  
**Tipo:** QUERY  
**Domínio:** TOTEM  
**Permissão requerida:** `TOTEM_PLANTAO_READ`  
**Executor:** `totem.plantao_medico_get`  
**SP:** A definir (consumir fonte canônica de escala)  
**Contexto:** `id_unidade`  
**Cache:** 1 minuto  

**Input:**
```json
{
  "id_unidade": 1,
  "data": "2026-07-29"
}
```

**Output:**
```json
{
  "plantao": []
}
```

---

### TOTEM_SENHA_GERAR

**Descrição:** Gerar senha de atendimento  
**Tipo:** COMMAND  
**Domínio:** TOTEM  
**Permissão requerida:** `TOTEM_SENHA_GERAR`  
**Executor:** `totem.gerar_senha`  
**SP:** `sp_totem_gerar_senha`  
**Contexto:** `id_unidade`, `id_local_operacional`  
**Idempotente:** Não  
**Auditoria:** Obrigatória  

**Input:**
```json
{
  "id_opcao": 1,
  "id_unidade": 1,
  "id_local_operacional": 1,
  "id_paciente": null
}
```

**Output:**
```json
{
  "id_senha": 123,
  "numero_senha": "C001",
  "tipo_atendimento": "CLINICO",
  "prefixo": "C",
  "uuid_transacao": "550e8400-e29b-41d4-a716-446655440000"
}
```

---

### TOTEM_FEEDBACK_READ

**Descrição:** Listar feedbacks de atendimento  
**Tipo:** QUERY  
**Domínio:** TOTEM  
**Permissão requerida:** `TOTEM_FEEDBACK_READ`  
**Executor:** `totem.feedback_get`  
**SP:** Query direta em `totem_feedback`  
**Contexto:** `id_senha` (opcional)  

**Input:**
```json
{
  "id_senha": 123
}
```

**Output:**
```json
{
  "feedbacks": []
}
```

---

### TOTEM_FEEDBACK_CREATE

**Descrição:** Registrar feedback de atendimento  
**Tipo:** COMMAND  
**Domínio:** TOTEM  
**Permissão requerida:** `TOTEM_FEEDBACK_CREATE`  
**Executor:** `totem.feedback_create`  
**SP:** Query direta em `totem_feedback`  
**Contexto:** `id_senha`  
**Auditoria:** Obrigatória  

**Input:**
```json
{
  "id_senha": 123,
  "origem": "TOTEM",
  "nota": 5,
  "comentario": "Atendimento rápido"
}
```

**Output:**
```json
{
  "id_feedback": 1,
  "mensagem": "Feedback registrado"
}
```

---

## Registry entry

```json
{
  "domain": "totem",
  "version": "1.0.0",
  "capabilities": [
    {
      "name": "TOTEM_OPCOES_READ",
      "type": "QUERY",
      "executor": "totem.opcoes_get",
      "permission": "TOTEM_OPCOES_READ",
      "context": ["id_unidade", "id_local_operacional"]
    },
    {
      "name": "TOTEM_PLANTAO_READ",
      "type": "QUERY",
      "executor": "totem.plantao_medico_get",
      "permission": "TOTEM_PLANTAO_READ",
      "context": ["id_unidade"]
    },
    {
      "name": "TOTEM_SENHA_GERAR",
      "type": "COMMAND",
      "executor": "totem.gerar_senha",
      "permission": "TOTEM_SENHA_GERAR",
      "context": ["id_unidade", "id_local_operacional"],
      "audit": true
    },
    {
      "name": "TOTEM_FEEDBACK_READ",
      "type": "QUERY",
      "executor": "totem.feedback_get",
      "permission": "TOTEM_FEEDBACK_READ",
      "context": ["id_senha"]
    },
    {
      "name": "TOTEM_FEEDBACK_CREATE",
      "type": "COMMAND",
      "executor": "totem.feedback_create",
      "permission": "TOTEM_FEEDBACK_CREATE",
      "context": ["id_senha"],
      "audit": true
    }
  ]
}
```

---

## Regras de registry

1. Toda capability deve ter nome canônico
2. Toda capability deve ter tipo (QUERY/COMMAND)
3. Toda capability deve ter executor mapeado
4. Toda capability deve ter permissão definida
5. Toda capability deve declarar contexto obrigatório
6. COMMANDs devem ter auditoria obrigatória

---

## Referências

- `MD-TOTEM-000` — Conceito do domínio
- `MD-TOTEM-001` — Contrato API
- `MD-REGISTRY-003-discovery-contracts.md` — Discovery Contracts
- `MAP-005-Portal-Architecture.md` — Portal Runtime
