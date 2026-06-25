# MAP-014 — Finance Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio financeiro.

## Classificação
```text
Tipo: Domain Architecture
Camada: Domínio
Prioridade: Alta
Obrigatoriedade: Corporativo
```

## Objetivo
Definir a arquitetura completa do Finance com bounded contexts, agregados, eventos e regras de negócio.

---

## Leis Canônicas Globais Aplicáveis

### LC-001 — Portal é a Entrada Oficial
```text
Login → Portal → Application Registry → Finance → Context Selection → Dashboard
```

### LC-005 — SP First Architecture
```text
Frontend → API → Service → Dispatcher → Stored Procedure → Database
```

### LC-006 — Tenant First
```text
Toda operação executa dentro de Tenant → Organização → Unidade
```

---

## Hierarquia de Domínios
```text
Finance Domain
├── Contas Context
├── Recebimentos Context
├── Pagamentos Context
├── Faturamento Context
└── CentroCusto Context
```

---

## Fluxo Financeiro Oficial
```text
Origem
↓
Lançamento
↓
Baixa
↓
Conciliação
↓
Relatório
```

---

## Bounded Contexts

### Contas Context
Responsável por: Conta, Tipo, Saldo, Limite, Movimento
Agregado: Conta

### Recebimentos Context
Responsável por: Recebimento, Cliente, Valor, Data, Forma, Baixa
Agregado: Recebimento

### Pagamentos Context
Responsável por: Pagamento, Fornecedor, Valor, Data, Status
Agregado: Pagamento

### Faturamento Context
Responsável por: Fatura, Itens, ISS, Desconto, Recebimento
Agregado: Fatura

---

## Agregados Principais

### Conta Aggregate
```text
conta_id (PK)
tenant_id (FK)
unit_id (FK)
tipo
saldo
limite
ativa
criado_em
```

### Recebimento Aggregate
```text
recebimento_id (PK)
conta_id (FK)
cliente_id (FK)
valor
data
forma
baixa
status
```

### Fatura Aggregate
```text
fatura_id (PK)
tenant_id (FK)
valor_total
iss
desconto
status
gerado_em
```

---

## Eventos Oficiais

### ContaCriada
Payload: {conta_id, tipo, saldo_inicial, tenant_id}

### RecebimentoRegistrado
Payload: {recebimento_id, conta_id, valor, forma}

### PagamentoEfetuado
Payload: {pagamento_id, fornecedor_id, valor, data}

### FaturaGerada
Payload: {fatura_id, atendimento_id, valor_total}

### FaturaPaga
Payload: {fatura_id, data_pagamento, forma}

---

## Stored Procedures

### sp_conta_criar
Input: {tipo, saldo, limite, unit_id}
Output: {conta_id}

### sp_recebimento_registrar
Input: {conta_id, cliente_id, valor, forma}
Output: {recebimento_id}

### sp_pagamento_efetuar
Input: {conta_id, fornecedor_id, valor}
Output: {pagamento_id}

### sp_fatura_gerar
Input: {atendimento_id, itens}
Output: {fatura_id, valor_total}

---

## APIs Oficiais

### /api/v1/finance/contas
POST - Criar conta
GET - Listar contas

### /api/v1/finance/recebimentos
POST - Registrar recebimento

---

## Regras Arquiteturais

### Origin Rule
Todo valor possui origem rastreável.

### SP First Rule
Toda escrita passa por Stored Procedure.

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-002 — Tenant | Tenant context |
| MAP-011 — HIS Domain | Faturamento assistencial |
| MD-071 — Customer 360 | Customer 360 |
| FRONT-038 — Financial Experience | UX |