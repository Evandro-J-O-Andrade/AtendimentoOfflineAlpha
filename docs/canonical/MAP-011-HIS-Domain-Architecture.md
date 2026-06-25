# MAP-011 — HIS Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio assistencial.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Crítica
Obrigatoriedade: Saúde
```

## Objetivo
Definir a arquitetura completa do HIS com bounded contexts, agregados, eventos e regras de negócio.
Esta é a fundação do core assistencial da plataforma.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → HIS → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-006 — Tenant First
```text
Toda operação executa dentro de Tenant → Organização → Unidade → Setor → Local
```

### LC-012 — Senha é Núcleo Operacional
```text
Fluxo canônico: Senha → Fila → FFA → Atendimento → Execução → Farmácia → Faturamento
```

### LC-PER-001 — Pessoa é Raiz
```text
Pessoa é a entidade raiz da plataforma Midas. Identidade pertence à Pessoa, não ao Tenant.
```

### MD-120 — Party Identity
```text
Pessoa possui múltiplos papéis. Paciente é um papel vinculado a Pessoa no contexto do Tenant.
```

---

## Lei Canônica MAP-011-001
```text
Paciente não entra no fluxo. Senha entra no fluxo.
```

---

## Hierarquia de Domínios
```text
Platform Core
│
├── IAM
├── Portal
├── AI
├── Analytics
├── Integration
│
└── HIS (Core Domain)
    ├── Senha Context
    ├── Fila Context
    ├── FFA Context
    ├── Atendimento Context
    ├── Prontuário Context
    ├── Farmácia Context
    ├── Internação Context
    └── Faturamento Context
```

---

## Fluxo Operacional Oficial
```text
Senha
↓
Fila
↓
FFA
↓
Atendimento
↓
Execução Clínica
↓
Farmácia
↓
Faturamento
```

---

## Bounded Contexts

### Senha Context
Responsável por: Senha, Prioridade, Status, Tempo de espera
Agregados: Senha

### Fila Context
Responsável por: Fila, Estatísticas, Localização, Ordem de chamada
Agregados: Fila

### FFA Context
Responsável por: FFA, Anamnese, Classificação de risco
Agregados: FFA

### Atendimento Context
Responsável por: Atendimento, Prescrição, Diagnóstico, Evolução
Agregados: Atendimento

### Prontuário Context
Responsável por: Histórico, Documentos, Exames, Procedimentos, Alergias
Agregados: Prontuário, Paciente

### Farmácia Context
Responsável por: Dispensação, Lotes, Validade, Medicamentos, Controlados
Agregados: Medicamento, Lote, Dispensacao

### Internação Context
Responsável por: Leito, Admissão, Alta, Enfermeiração, Dieta
Agregados: Leito, Admissao

### Faturamento Context
Responsável por: Conta, Itens, ISS, Desconto, Recebimento
Agregados: Conta, Faturamento

---

## Agregados Principais

### Senha Aggregate
```text
senha_id (PK)
tenant_id (FK)
queue_id (FK)
person_role_id (FK) - referência ao papel PACIENTE
queue_number
priority
status
guiche
called_by (user_id)
created_at
updated_at
```

---

### Paciente Context (via Person-Role)
Paciente é um papel vinculado a Pessoa (MD-120).

Através de:
```text
Person
↓
Role Assignment (PACIENTE)
↓
Tenant
↓
Senha
```

---

### Fila Aggregate
```text
fila_id (PK)
tenant_id (FK)
unit_id (FK)
name
type
capacity
current_size
ativa
```

### Atendimento Aggregate
```text
atendimento_id (PK)
senha_id (FK)
medico_id
enfermeiro_id
status
inicio
fim
procedimentos
diagnosticos
```

### Prontuário Aggregate
```text
prontuario_id (PK)
paciente_id (FK)
tenant_id (FK)
historico
documentos
exames
alergias
```

---

## Eventos Oficiais

### SenhaCriada
Payload: {senha_id, tenant_id, fila_id, priority, created_by, timestamp}

### SenhaChamada
Payload: {senha_id, guiche, atendente_id, contexto, setor, display, timestamp}

### SenhaAtendida
Payload: {senha_id, atendimento_id, timestamp}

### GPATCriado
Payload: {gpat_id, senha_id, person_role_id, tipo_atendimento, created_by, timestamp}

### FFACriada
Payload: {ffa_id, gpat_id, classificacao_risco, sinais_vitais, created_by, timestamp}

### AtendimentoIniciado
Payload: {atendimento_id, senha_id, medico_id, ffa_id, unidade_id, created_by, timestamp}

### TriagemRealizada
Payload: {triagem_id, atendimento_id, sinais_vitais, classificacao, created_by, timestamp}

### PacienteChamadoConsultorio
Payload: {evento_id, senha_id, consultorio, created_by, timestamp}

### PrescricaoEmitida
Payload: {prescricao_id, atendimento_id, medicamento_id, dosagem, via, frequencia, created_by, timestamp}

### ExameSolicitado
Payload: {exame_id, atendimento_id, tipo, created_by, timestamp}

### MedicacaoAdministrada
Payload: {medicacao_id, prescricao_id, enfermeiro_id, dose, horario, created_by, timestamp}

### MedicamentoDispensado
Payload: {dispensacao_id, prescricao_id, lote_id, quantidade, validado_por, timestamp}

### LeitoAtribuido
Payload: {internacao_id, leito_id, paciente_id, created_by, timestamp}

### TransferenciaLeito
Payload: {transferencia_id, internacao_id, origem, destino, motivo, created_by, timestamp}

### AltaConcedida
Payload: {alta_id, internacao_id, tipo_alta, desfecho, created_by, timestamp}

### ObitoRegistrado
Payload: {obito_id, internacao_id, causa, created_by, timestamp}

---

## Leis Operacionais HIS

### LEI HIS-001 — Senha é Gatilho Operacional
```text
Fluxo inicia com Senha, não com Paciente.
Paciente nasce do Atendimento ativo.
```

### LEI HIS-002 — Agregados Fundamentais
```text
Senha, GPAT, FFA, Atendimento, Prescrição, Dispensação, Leito são agregados raiz.
Cada um possui seu ciclo de vida.
Cada mudança gera evento.
```

### LEI HIS-003 — Fluxos por Tipo
```text
Ambulatório/UBS = Agendamento
UPA/PS/Emergência = Senha
Internação = Leito
Farmácia = Prescrição/Dispensação
Convênio = Guia/Autorização
Remoção = Solicitação Transporte
```

### LEI HIS-004 — Evento é História Oficial
```text
Todo evento contém:
data
hora
usuario
contexto
setor
display
motivo
```

### LEI HIS-005 — SP + Evento Integrado
```text
sp_criar_senha()
  ↓
INSERT senha
INSERT evento SenhaCriada
INSERT auditoria
```

---

## Agregados Complementares

### GPAT Aggregate
```text
gpat_id (PK)
senha_id (FK)
person_role_id (FK)
tipo_atendimento
dados_cadastrais
status
created_at
updated_at
```

### Prescricao Aggregate
```text
prescricao_id (PK)
atendimento_id (FK)
medico_id (FK)
medicamento_id (FK)
dosagem
via
frequencia
duracao
status
prescrita_em
```

### Dispensacao Aggregate
```text
dispensacao_id (PK)
prescricao_id (FK)
lote_id (FK)
quantidade
validada_por
validada_em
status
```

### Leito Aggregate
```text
leito_id (PK)
unidade_id (FK)
numero
tipo
status
paciente_id (FK) - quando ocupado
admitido_em
liberado_em
```

### Internacao Aggregate
```text
internacao_id (PK)
leito_id (FK)
atendimento_id (FK)
alta_id (FK) - quando finalizada
status
evolucao
dieta
medicao
```

---

## Fluxos Canônicos do Domínio Saúde

### UPA/PS/Emergência (Fluxo Senha)
```text
Senha
↓
Fila
↓
GPAT
↓
FFA
↓
Atendimento
↓
Execução
↓
Desfecho
```

### Agendamento (UBS/Atenção Básica)
```text
Agendamento
↓
Recepção
↓
Atendimento
↓
Receita
↓
Encerramento
```

### Farmácia Popular/Rua
```text
Receita Externa
↓
Validação
↓
Dispensação
↓
Registro
```

### Convênio
```text
Atendimento
↓
Guia
↓
Autorização
↓
Execução
↓
Faturamento
```

### Internação
```text
Leito
↓
Admissão
↓
Evoluções
↓
Prescrições
↓
Exames
↓
Transferências
↓
Alta/Óbito
```

### Remoção
```text
Solicitação
↓
Regulação
↓
Veículo
↓
Equipe
↓
Destino
↓
Conclusão
```

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant | Tenant/Unit context |
| MAP-003 — Identity | Auth/Authorization |
| MD-105 — HIS Canonical Flow | Flow patterns |
| MD-120 — Party Identity | Person-Role model |
| MD-065 — Observability | Monitoring |
| FRONT-031 — HIS Operational | UX |
| FRONT-033 — Clinical Workspace | Clinical UX |