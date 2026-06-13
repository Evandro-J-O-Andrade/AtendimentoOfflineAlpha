# MAPA DE INTEGRAÇÃO FRONTEND ↔ STORED PROCEDURES

## Visão Geral

Este documento mapeia as ações que o frontend chama através do dispatcher para as Stored Procedures do banco de dados.

---

## 1. FLUXO DE CHAMADA

```
Frontend (React/PHP)
       ↓
dispatchKernel() / API /dispatch
       ↓
sp_master_dispatcher_runtime
       ↓
sp_ledger_evento_log (auditoria)
```

---

## 2. AÇÕES DO FRONTEND E SPs CORRESPONDENTES

### 2.1 ATENDIMENTO

| Ação Frontend | Stored Procedure | Contexto | Descrição |
|--------------|-----------------|----------|-----------|
| `ATENDIMENTO_INICIAR` | [`sp_master_atendimento_iniciar`](sp_master_atendimento_iniciar) | ATENDIMENTO | Inicia novo atendimento |
| `ATENDIMENTO_TRANSICIONAR` | [`sp_master_atendimento_transicionar`](sp_master_atendimento_transicionar) | ATENDIMENTO | Transiciona status do atendimento |
| `ATENDIMENTO_FINALIZAR` | [`sp_master_atendimento_finalizar`](sp_master_atendimento_finalizar) | ATENDIMENTO | Finaliza atendimento |
| `ATENDIMENTO_CANCELAR` | [`sp_master_atendimento_cancelar`](sp_master_atendimento_cancelar) | ATENDIMENTO | Cancela atendimento |
| `ATENDIMENTO_VINCULAR_PACIENTE` | [`sp_master_vincular_atendimento_paciente`](sp_master_vincular_atendimento_paciente) | ATENDIMENTO | Vincula paciente ao atendimento |

### 2.2 PACIENTE

| Ação Frontend | Stored Procedure | Contexto | Descrição |
|--------------|-----------------|----------|-----------|
| `PACIENTE_ATUALIZAR` | [`sp_master_atualizar_paciente`](sp_master_atualizar_paciente) | PACIENTE | Atualiza dados do paciente |

### 2.3 SENHA/FILA

| Ação Frontend | Stored Procedure | Contexto | Descrição |
|--------------|-----------------|----------|-----------|
| `SENHA_CRIAR` | via dispatcher | RECEPCAO | Cria nova senha |
| `SENHA_CHAMAR` | via dispatcher | RECEPCAO | Chama próxima senha |
| `SENHA_ATENDER` | via dispatcher | ATENDIMENTO | Atende senha chamada |

### 2.4 AGENDA

| Ação Frontend | Stored Procedure | Contexto | Descrição |
|--------------|-----------------|----------|-----------|
| `AGENDA_DISPONIBILIDADE_CRIAR` | [`sp_master_agenda_disponibilidade`](sp_master_agenda_disponibilidade) | AGENDA | Registra disponibilidade |
| `AGENDAMENTO_EVENTO_CRIAR` | [`sp_master_agendamento_eventos`](sp_master_agendamento_eventos) | AGENDA | Cria evento na agenda |

### 2.5 MEDICAÇÃO/FARMÁCIA

| Ação Frontend | Stored Procedure | Contexto | Descrição |
|--------------|-----------------|----------|-----------|
| `ADMINISTRACAO_MEDICACAO_REGISTRAR` | [`sp_master_registrar_administracao_medicacao`](sp_master_registrar_administracao_medicacao) | FARMACIA | Registra administração |
| `ADMINISTRACAO_MEDICACAO_CANCELAR` | [`sp_master_cancelar_administracao_medicacao`](sp_master_cancelar_administracao_medicacao) | FARMACIA | Cancela administração |
| `ADMINISTRACAO_MEDICACAO_ORDEM` | [`sp_master_administracao_medicacao_ordem`](sp_master_administracao_medicacao_ordem) | FARMACIA | Cria ordem de medicação |

### 2.6 ALERTAS

| Ação Frontend | Stored Procedure | Contexto | Descrição |
|--------------|-----------------|----------|-----------|
| `ALERTA_REGISTRAR` | [`sp_master_registrar_alerta`](sp_master_registrar_alerta) | ALERTA | Registra alerta |
| `ALERTA_CONSUMO` | [`sp_master_alerta_consumo`](sp_master_alerta_consumo) | ALERTA | Registra alerta de consumo |

---

## 3. PAYLOADS ESPERADOS POR AÇÃO

### ATENDIMENTO_INICIAR
```json
{
  "id_atendimento": 123,
  "id_paciente": 456
}
```

### ATENDIMENTO_TRANSICIONAR
```json
{
  "id_atendimento": 123,
  "status": "EM_CONSULTA"
}
```

### ATENDIMENTO_FINALIZAR
```json
{
  "id_atendimento": 123
}
```

### PACIENTE_ATUALIZAR
```json
{
  "id_paciente": 456,
  "nome": "João Silva"
}
```

### ATENDIMENTO_VINCULAR_PACIENTE
```json
{
  "id_atendimento": 123,
  "id_paciente": 456
}
```

### AGENDA_DISPONIBILIDADE_CRIAR
```json
{
  "id_profissional": 1,
  "id_unidade": 2,
  "data_inicio": "2026-03-10 08:00:00",
  "data_fim": "2026-03-10 12:00:00",
  "status": "ATIVA"
}
```

### AGENDAMENTO_EVENTO_CRIAR
```json
{
  "id_agenda": 1,
  "tipo_evento": "CONSULTA",
  "descricao": "Consulta de rotina",
  "data_evento": "2026-03-10 09:00:00",
  "status": "PENDENTE"
}
```

### ADMINISTRACAO_MEDICACAO_REGISTRAR
```json
{
  "id_atendimento": 123,
  "medicamento": "Dipirona",
  "dose": "500mg",
  "via": "Oral"
}
```

### ADMINISTRACAO_MEDICACAO_CANCELAR
```json
{
  "id_administracao": 1,
  "id_atendimento": 123,
  "motivo": "Paciente recusou"
}
```

### REGISTRAR_ALERTA
```json
{
  "tipo": "ALERTA_CLINICO",
  "descricao": "Paciente alérgico",
  "prioridade": 3,
  "id_destinatario": 5
}
```

### ALERTA_CONSUMO
```json
{
  "tipo_alerta": "ESTOQUE_BAIXO",
  "descricao": "Medicamento em falta",
  "id_unidade": 2,
  "id_funcionario": 1,
  "status": "ABERTO"
}
```

---

## 4. STATUS DO FLUXO (fluxo_status.codigo)

| Código | Descrição | Tipo |
|--------|-----------|------|
| INICIO | Entrada do paciente | INICIAL |
| AGUARDANDO_TRIAGEM | Aguardando triagem | OPERACIONAL |
| EM_TRIAGEM | Em triagem | OPERACIONAL |
| AGUARDANDO_CONSULTA | Aguardando consulta | OPERACIONAL |
| EM_CONSULTA | Em consulta médica | OPERACIONAL |
| AGUARDANDO_EXAMES | Aguardando exames | OPERACIONAL |
| EM_EXAME | Em exame | OPERACIONAL |
| MEDICACAO_INTERNA | Em medicação interna | OPERACIONAL |
| ALTA_MEDICA | Alta médica concedida | INTERMEDIARIO |
| EVASAO | Paciente evadiu | FINAL |
| NAO_COMPARECEU | Não compareceu | FINAL |
| FINALIZADO | Atendimento finalizado | FINAL |

---

## 5. TABELAS PRINCIPAIS

### atendimento
- `id_atendimento` (PK)
- `protocolo`
- `id_pessoa` (FK)
- `status_atendimento`
- `data_abertura`
- `data_fechamento`

### senha
- `id_senha` (PK)
- `id_atendimento` (FK)
- `id_fluxo_status` (FK)
- `id_paciente` (FK)
- `criado_em`

### paciente
- `id` (PK)
- `nome`
- `documento_principal`

### fluxo_status
- `id_fluxo_status` (PK)
- `codigo`
- `descricao`

---

## 6. IMPLEMENTAÇÃO

Para que o frontend chame as SPs corretamente, a `sp_master_dispatcher_runtime` deve ser atualizada para incluir todas as ações no CASE.

Ver arquivo: `backend/sql/sp_master_dispatcher_runtime_atualizada.sql`
