# MAP-016 — SAC Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio de atendimento ao cliente.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

## Objetivo
Definir a arquitetura completa do SAC com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → SAC → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-008 — Audit First
```text
Todo ticket é auditável.
```

---

## Hierarquia de Domínios
```text
SAC Domain
├── Ticket Context
├── Fila Context
├── Atendimento Context
└── Solução Context
```

---

## Fluxo SAC Oficial
```text
Ticket
↓
Atribuição
↓
Resposta
↓
Solução
↓
Encerramento
```

---

## Bounded Contexts

### Ticket Context
Responsável por: Ticket, Cliente, Tipo, Prioridade, Status, SLA
Agregado: Ticket

### Fila Context
Responsável por: Fila, Equipe, Estatísticas, SLA
Agregado: Fila

### Atendimento Context
Responsável por: Interação, Resposta, Anexos, Categoria
Agregado: Interacao

### Solução Context
Responsável por: Solução, Categoria, Feedback, Encerramento
Agregado: Solucao

---

## Agregados Principais

### Ticket Aggregate
```text
ticket_id (PK)
tenant_id (FK)
cliente_id (FK)
tipo
prioridade
status
sla_deadline
criado_por
atribuido_a
created_at
```

### Interacao Aggregate
```text
interacao_id (PK)
ticket_id (FK)
tipo
conteudo
atendente_id
anexos
created_at
```

---

## Eventos Oficiais

### TicketCriado
Payload: {ticket_id, cliente_id, tipo, prioridade, sla_deadline}

### TicketAtribuido
Payload: {ticket_id, atendente_id, timestamp}

### SLAVencendo
Payload: {ticket_id, tempo_restante}

### TicketResolvido
Payload: {ticket_id, solucao, avaliacao}

### TicketEncerrado
Payload: {ticket_id, feedback, encerrado_em}

---

## Stored Procedures

### sp_ticket_criar
Input: {cliente_id, tipo, assunto, descricao}
Output: {ticket_id, numero}

### sp_ticket_atribuir
Input: {ticket_id, atendente_id}
Output: {status}

### sp_sla_calcular
Input: {tipo, prioridade}
Output: {sla_deadline}

### sp_ticket_encerrar
Input: {ticket_id, solucao, feedback}
Output: {status}

---

## APIs Oficiais

### /api/v1/sac/tickets
POST - Criar ticket
GET - Listar tickets por status

### /api/v1/sac/tickets/{id}/interacoes
POST - Adicionar interação

---

## Regras Arquiteturais

### SLA Rule
Todo ticket tem prazo de resolução.

### SP First Rule
Toda escrita passa por Stored Procedure.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant | Tenant context |
| MAP-077 — Social | Canais |
| MD-073 — SAC Omnichannel | SAC patterns |
| FRONT-036 — SAC Experience | UX |
| FRONT-073 — Enterprise Chat | Chat |