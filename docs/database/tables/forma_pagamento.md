# forma_pagamento

Objetivo: Catalogar as formas de pagamento disponíveis no sistema.

Descrição: Tabela que armazena as formas de pagamento aceitas pelo sistema (dinheiro, PIX, cartões, convênios, etc). Utilizada em transações financeiras para identificar como o pagamento foi ou será realizado.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|---------|------|----------|---------|------------------|
| id_forma_pagamento | int | NOT NULL | - | Identificador único da forma de pagamento, chave primária auto incrementada |
| codigo | varchar(30) | NOT NULL | - | Código único da forma de pagamento (ex: DINHEIRO, PIX, CREDITO) |
| descricao | varchar(80) | DEFAULT NULL | - | Descrição da forma de pagamento (ex: Dinheiro, PIX, Cartão de crédito) |
| id_entidade | bigint unsigned | DEFAULT NULL | - | Referência à entidade (organização) associada |

## Chaves
- Primária: id_forma_pagamento
- Únicas: uk_fp_codigo (codigo) - garante código único
- Estrangeiras: -

## Índices
- -

## Constraints
- UNIQUE KEY uk_fp_codigo (codigo)

## Relacionamentos e Cardinalidade
- forma_pagamento é referenciada por tabelas de movimento financeiro (vendas, pagamentos)

## Dependências
- Tabelas que dependem desta: -
- Esta tabela depende de: -

## Fluxo de utilização dentro do sistema
1. Formas de pagamento são cadastradas com código e descrição
2. Códigos padrão: DINHEIRO, PIX, DEBITO, CREDITO, CONVENIO, OUTRO
3. UNIQUE KEY garante que não haja duplicidade de códigos
4. Utilizada em transações para definir como o pagamento deve ser realizado