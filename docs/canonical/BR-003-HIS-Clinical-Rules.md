# BR-003 — HIS Clinical Rules

## Status
Documento Canônico de Regras de Negócio.
Regras operacionais do domínio assistencial.

---

## Lei Base

```text
LC-005 — Senha é o núcleo operacional assistencial.

LC-006 — Paciente possui histórico. Senha possui fluxo.

LC-007 — SP First Architecture.

LC-012 — Tenant First.
```

---

## Regras

### Briefing
```text
REGRA-003-01: Todo atendimento inicia por senha

REGRA-003-02: Paciente não inicia fluxo

REGRA-003-03: Senha é entidade operacional

REGRA-003-04: Paciente é entidade longitudinal
```

### Senha e Fila
```text
REGRA-003-05: Senha criada exclusivamente por recepção

REGRA-003-06: Senha vinculada obrigatoriamente a uma fila

REGRA-003-07: Senha possui prioridade calculada

REGRA-003-08: Fila respeita ordem de prioridade + chegada

REGRA-003-09: Transferência de fila registrada em evento

REGRA-003-10: Rechamada registrada com limite de 3

REGRA-003-11: Ausência gera cancelamento automático
```

### FFA
```text
REGRA-003-12: Abertura de FFA exclusiva da recepção

REGRA-003-13: FFA vinculada obrigatoriamente a senha

REGRA-003-14: Dados de identificação obrigatórios

REGRA-003-15: Motivo do atendimento obrigatório

REGRA-003-16: Convênio validado antes da FFA
```

### Triagem
```text
REGRA-003-17: Triagem obrigatória antes do médico

REGRA-003-18: Sinais vitais registrados em enfermagem

REGRA-003-19: Dados sensíveis protegidos conforme LGPD

REGRA-003-20: Classificação de risco obrigatória
```

### Atendimento Médico
```text
REGRA-003-21: Médico confirma identidade antes do atendimento

REGRA-003-22: Prontuário aberto automaticamente

REGRA-003-23: Tempo de atendimento registrado

REGRA-003-24: Exames solicitados vinculados ao atendimento

REGRA-003-25: Prescrição gerada pelo médico responsável

REGRA-003-26: CRM obrigatório na prescrição
```

### Execução Clínica
```text
REGRA-003-27: Enfermagem executa prescrições validadas

REGRA-003-28: Administração de medicamentos registrada

REGRA-003-29: Interações medicamentosas alertadas

REGRA-003-30: Reações adversas registradas
```

### Farmácia
```text
REGRA-003-31: Dispensação vinculada à prescrição

REGRA-003-32: Lote e validade obrigatórios

REGRA-003-33: Medicamentos controlados validados

REGRA-003-34: Estoque baixo gera alerta automático
```

### Faturamento
```text
REGRA-003-35: Fatura gerada após encerramento do atendimento

REGRA-003-36: Procedimentos conforme tabela oficial

REGRA-003-37: Glosas registradas com justificativa

REGRA-003-38: Repasse calculado por regras contratuais

REGRA-003-39: Cobrança respeita plano do paciente
```

### Multitenancy
```text
REGRA-003-40: Todos os dados escopados por tenant

REGRA-003-41: tenant_id obrigatório em toda operação

REGRA-003-42: Nenhuma consulta global permitida
```

### Auditoria
```text
REGRA-003-43: Toda ação crítica gera evento

REGRA-003-44: Timeline imutável

REGRA-003-45: Acesso a prontuário sempre registrado

REGRA-003-46: Alteração de status com justificativa
```

---

## Operações Proibidas

```text
REGRA-003-47: Deleção direta de senha

REGRA-003-48: Atualização de prontuário sem versão

REGRA-003-49: Acesso a prontuário sem permissão

REGRA-003-50: Circulação de dados fora do tenant
```

---

## Stored Procedures Obrigatórias

### sp_senha_criar
Valida regras de criação e atribui prioridade.

### sp_senha_chamar
Aplica regras de chamada e fila.

### sp_ffa_abrir
Cria FFA com validações obrigatórias.

### sp_atendimento_iniciar
Registra início com contexto completo.

### sp_prescricao_emitir
Gera prescrição com validações.

### sp_dispensacao_registrar
Registra dispensação e atualiza estoque.

### sp_fatura_gerar
Gera fatura com itens do atendimento.

---

## Eventos Obrigatórios

### Eventos de Senha
```text
SenhaCriada
SenhaChamada
SenhaPriorizada
SenhaTransferida
SenhaAusente
SenhaCancelada
SenhaConcluida
```

### Eventos de Atendimento
```text
FFAAberta
TriagemRegistrada
AtendimentoIniciado
PrescricaoEmitida
MedicamentoDispensado
AtendimentoConcluido
```

---

## Integrações

| COMPONENTE | Finalidade |
|------------|------------|
| FRONT-032 — Queue Panel | Painéis de fila |
| FRONT-033 — Clinical Workspace | Workspace clínico |
| FRONT-034 — Pharmacy | Farmácia |
| FRONT-040 — Offline First | Operação offline |
| MAP-011 — HIS Domain | Domínio HIS |