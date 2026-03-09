# Fluxo de Senhas - Diagrama de Sequência

## Visão Geral do Fluxo

```
Paciente → Totem → Painel → Guichê → FFA/GPAT
```

---

## 1. FLUXO PRINCIPAL

### 1.1 Paciente gera senha no Totem

```
Paciente → sp_totem_gerar_senha(p_id_paciente, tipo_senha)
          ↓
    Retorna número visível (ex: CLINI-001)
          ↓
    Inserir registro de senha (GERADA) + ledger
```

**Payload:**
```json
{
  "acao": "TOTEM_GERAR_SENHA",
  "contexto": "SENHA",
  "payload": {
    "id_paciente": 123,
    "tipo_senha": "NORMAL"
  }
}
```

**SP:** `sp_totem_gerar_senha`

---

### 1.2 Painel recebe nova senha

```
Painel → sp_painel_inserir_senha(id_senha)
         ↓
    Atualiza status da senha para PENDENTE + ledger
```

**Status:** `GERADA → PENDENTE`

---

### 1.3 Guichê chama paciente

```
Painel → sp_painel_chamar_senha(id_senha, id_guiche)
         ↓
    TTS: "Senha CLINI-001, comparecer no guichê 2"
         ↓
    Atualiza status para CHAMADA, bloqueia guichê + ledger
```

**Status:** `PENDENTE → CHAMADA`

**Payload:**
```json
{
  "acao": "CHAMAR_SENHA",
  "contexto": "SENHA",
  "payload": {
    "id_senha": 1,
    "id_guiche": 2
  }
}
```

---

### 1.4 Paciente comparece ao guichê

```
Guichê → Complementar atendimento (sp_complementar_senha)
         ↓
    Cria registro FFA
         ↓
    Gera GPAT
         ↓
    Atualiza status para COMPLEMENTADA + ledger
```

**Status:** `CHAMADA → COMPLEMENTADA`

---

## 2. STATUS DAS SENHAS

| Status | Descrição |
|--------|-----------|
| GERADA | Senha gerada no totem, ainda não chamada |
| PENDENTE | Senha inserida no painel, aguardando chamada |
| CHAMADA | Senha chamada pelo guichê, aguardando comparecimento |
| COMPLEMENTADA | Atendimento complementado no guichê |
| CANCELADA | Senha cancelada |
| NAO_ATENDIDA | Paciente não compareceu |

---

## 3. SPs DO FLUXO

| SP | Ação | Descrição |
|----|------|-----------|
| `sp_totem_gerar_senha` | TOTEM_GERAR_SENHA | Gera senha no totem |
| `sp_painel_inserir_senha` | SENHA_INSERIR | Insere senha no painel |
| `sp_painel_chamar_senha` | CHAMAR_SENHA | Chama senha no guichê |
| `sp_complementar_senha` | COMPLEMENTAR_SENHA | Complementa atendimento |
| `sp_painel_cancelar_senha` | CANCELAR_SENHA | Cancela senha |

---

## 4. FLUXOS ALTERNATIVOS

### 4.1 Senha interna/manual (não aparece no painel)

```
Recepção → Cria senha interna oculta
           ↓
    Auditoria e ledger
           ↓
    Não aparece no painel
```

### 4.2 Direcionamento para triagem

```
Se paciente grave
    → Direciona para triagem ou emergência
```

### 4.3 Cancelamento

```
Recepção → sp_painel_cancelar_senha(id_senha, motivo)
           ↓
    Atualiza status para CANCELADA ou NAO_ATENDIDA
           ↓
    Move senha para lista lateral correspondente
```

---

## 5. REGRAS IMPORTANTES

1. **TTS** - Executado apenas para senhas do Totem (visíveis ao paciente)
2. **Bloqueio de guichê** - Uma senha só pode ser chamada por um guichê por vez
3. **GPAT** - Pré-gerado ao chamar ou complementar para rastreabilidade e rollback seguro
4. **Ledger** - Todas as ações são logadas com UUID de transação, usuário, perfil e motivo
5. **Auditoria** - Senhas internas também são auditadas

---

## 6. PAYLOADS DE REFERÊNCIA

### TOTEM_GERAR_SENHA
```json
{
  "acao": "TOTEM_GERAR_SENHA",
  "contexto": "SENHA",
  "payload": {
    "id_paciente": 123,
    "tipo_senha": "NORMAL"
  }
}
```

### CHAMAR_SENHA
```json
{
  "acao": "CHAMAR_SENHA",
  "contexto": "SENHA",
  "payload": {
    "id_senha": 1,
    "id_guiche": 2
  }
}
```

### COMPLEMENTAR_SENHA
```json
{
  "acao": "COMPLEMENTAR_SENHA",
  "contexto": "SENHA",
  "payload": {
    "id_senha": 1,
    "id_atendimento": 100,
    "id_paciente": 123
  }
}
```

### CANCELAR_SENHA
```json
{
  "acao": "CANCELAR_SENHA",
  "contexto": "SENHA",
  "payload": {
    "id_senha": 1,
    "motivo": "Paciente não compareceu"
  }
}
```
