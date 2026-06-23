# MAP-011 — HIS Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio assistencial.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Crítica
Obrigatoriedade: Saúde
```

---

## Objetivo
Definir arquitetura completa do HIS com bounded contexts e agregados.

---

## Lei Canônica MAP-011-001
```text
Paciente não inicia fluxo.
Senha inicia fluxo.
```

---

## Bounded Contexts

### Senha Context
Responsável por:
```text
Senha
Prioridade
Status
Atendimento
Tempo de espera
```

### Fila Context
Responsável por:
```text
Fila
Estatísticas
Localização
Transição
Ordem de chamada
```

### Atendimento Context
Responsável por:
```text
FFA
Anamnese
Prescrição
Evolução
Diagnóstico
```

### Prontuário Context
Responsável por:
```text
Histórico
Documentos
Exames
Procedimentos
Alergias
```

### Farmácia Context
Responsável por:
```text
Dispensação
Lotes
Validade
Medicamentos
Controlados
```

### Internação Context
Responsável por:
```text
Leito
Admissão
Alta
Enfermeiração
Dieta
```

---

## Agregados Principais

### Senha Aggregate
```text
senha_id
paciente_id
tenant_id
fila_id
prioridade
status
created_at
updated_at
```

### Fila Aggregate
```text
fila_id
tenant_id
unit_id
name
type
capacity
current_size
```

### Atendimento Aggregate
```text
atendimento_id
senha_id
medico_id
enfermeiro_id
status
inicio
fim
procedimentos
```

### Prontuário Aggregate
```text
prontuario_id
paciente_id
tenant_id
historico
documentos
exames
```

---

## Eventos Oficiais

### SenhaCriada
### SenhaChamada
### SenhaAtendida
### AtendimentoIniciado
### AtendimentoConcluido
### MedicamentoDispensado
### LeitoOcupado
### LeitoLiberado

---

## Stored Procedures

### sp_senha_criar
### sp_senha_chamar
### sp_senha_priorizar
### sp_senha_transferir
### sp_fila_consultar
### sp_atendimento_iniciar
### sp_atendimento_finalizar

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MAP-002 — Tenant | Tenant |
| MD-105 — HIS Canonical Flow | Flow |
| FRONT-031 — HIS Operational | UX |
| FRONT-033 — Clinical Workspace | Clínico |