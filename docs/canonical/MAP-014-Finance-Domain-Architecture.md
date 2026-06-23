# MAP-014 — Finance Domain Architecture

## Status
Documento Canônico de Arquitetura.
Arquitetura do domínio financeiro.

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
Definir arquitetura financeira com foco em fluxo de caixa e controle.

---

## Bounded Contexts

### Contas Context
```text
Conta
Tipo
Saldo
Movimento
Histórico
```

### Recebimentos Context
```text
Recebimento
Cliente
Valor
Data
Forma
```

### Pagamentos Context
```text
Pagamento
Fornecedor
Valor
Data
Status
```

### Faturamento Context
```text
Fatura
Itens
Valor
ISS
Desconto
```

---

## Agregados

### Conta Aggregate
```text
conta_id
tenant_id
unit_id
tipo
saldo
limite
```

### Recebimento Aggregate
```text
recebimento_id
conta_id
cliente_id
valor
data
baixa
```

---

## Eventos Oficiais

### ContaCriada
### RecebimentoRegistrado
### PagamentoEfetuado
### FaturaGerada
### FaturaPaga

---

## Stored Procedures

### sp_conta_criar
### sp_recebimento_registrar
### sp_pagamento_efetuar
### sp_fatura_gerar

---

## Integrações
| MAP/MD | Finalidade |
|--------|-----------|
| MAP-001 — Enterprise Domain | Foundation |
| MD-071 — Customer 360 | CRM |
| FRONT-038 — Financial Experience | UX |
| FRONT-051 — Customer 360 | 360° |