# MAP-016 — SAC Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de atendimento ao cliente.

---

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

---

## Objetivo
Definir arquitetura do SAC com foco em resolução e SLA.

---

## Bounded Contexts

### Ticket Context
```text
Ticket
Cliente
Tipo
Prioridade
Status
```

### Fila Context
```text
Fila
Equipe
Estatísticas
SLA
```

### Atendimento Context
```text
Interação
Resposta
Anexos
Categoria
```

### Solução Context
```text
Solução
Categoria
Feedback
Encerramento
```

---

## Agregados

### Ticket Aggregate
```text
ticket_id
tenant_id
cliente_id
tipo
prioridade
status
sla_deadline
created_at
```

### Interacao Aggregate
```text
interacao_id
ticket_id
tipo
conteudo
atendente_id
created_at
```

---

## Eventos Oficiais

### TicketCriado
### TicketAtribuido
### SLAVencendo
### TicketResolvido
### TicketEncerrado

---

## Stored Procedures

### sp_ticket_criar
### sp_ticket_atribuir
### sp_sla_calcular
### sp_ticket_encerrar

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-073 — SAC Omnichannel | SAC |
| FRONT-036 — SAC Experience | UX |
| FRONT-073 — Enterprise Chat | Chat |