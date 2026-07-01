# pdv_venda

Objetivo: Registrar vendas realizadas no Ponto de Venda (PDV).
Descrição: Tabela principal do PDV que armazena o cabeçalho de cada venda, incluindo cliente, estoque, valores totais e status da venda.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_venda | bigint | NOT NULL | - | Identificador único da venda (chave primária, auto incremento) |
| id_estoque_local | bigint | NOT NULL | - | ID do local de estoque onde os produtos são retirados |
| id_cliente | bigint | YES | NULL | ID do cliente que realizou a compra |
| id_codigo_universal | bigint | YES | NULL | ID do código universal do produto (para venda de código único) |
| codigo | varchar(60) | YES | NULL | Código do produto vendido (quando não usa código universal) |
| barcode | varchar(60) | YES | NULL | Código de barras do produto |
| status | enum('ABERTA','PAGA','CANCELADA') | NOT NULL | 'ABERTA' | Status da venda: aberta, paga ou cancelada |
| total_bruto | decimal(14,2) | NOT NULL | '0.00' | Valor bruto total antes de descontos |
| desconto | decimal(14,2) | NOT NULL | '0.00' | Valor total de descontos aplicados |
| total_liquido | decimal(14,2) | NOT NULL | '0.00' | Valor líquido total a ser pago |
| id_sessao_usuario | bigint | NOT NULL | - | ID da sessão do usuário que realizou a venda |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de criação da venda |
| pago_em | datetime | YES | NULL | Data/hora em que a venda foi paga |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual a venda pertence |

## Chaves
- Primária: id_venda
- Únicas: (nenhuma)
- Estrangeiras: 
  - fk_pdv_venda_cliente: id_cliente → cliente (id_cliente) com SET NULL
  - fk_pdv_venda_codigo: id_codigo_universal → codigo_universal (id_codigo) com SET NULL
  - fk_pdv_venda_local: id_estoque_local → estoque_local (id_estoque_local) com RESTRICT

## Índices
- PRIMARY KEY (id_venda)
- KEY ix_venda_status (status)
- KEY ix_venda_cliente (id_cliente)
- KEY fk_pdv_venda_local (id_estoque_local)
- KEY fk_pdv_venda_sessao (id_sessao_usuario)
- KEY fk_pdv_venda_codigo (id_codigo_universal)

## Constraints
- PRIMARY KEY: id_venda
- FOREIGN KEY: fk_pdv_venda_cliente
- FOREIGN KEY: fk_pdv_venda_codigo
- FOREIGN KEY: fk_pdv_venda_local

## Relacionamentos e Cardinalidade
- 1:N com pdv_venda_item: Uma venda pode ter muitos itens
- 1:N com pdv_pagamento: Uma venda pode ter muitos pagamentos
- N:1 com cliente: Muitas vendas podem estar associadas a um cliente
- N:1 com estoque_local: Muitas vendas podem usar um local de estoque
- N:1 com sessao_usuario: Muitas vendas podem ter uma sessão associada
- N:1 com codigo_universal: Muitas vendas podem usar um código universal

## Dependências
- Esta tabela depende de: cliente, estoque_local, sessao_usuario, codigo_universal, saas_entidade
- Tabelas que dependem desta: pdv_venda_item, pdv_pagamento

## Fluxo de utilização dentro do sistema
Utilizada como registro principal do PDV. Quando uma venda é iniciada, é criado um registro com status ABERTA. Os itens são adicionados em pdv_venda_item. Ao finalizar, o status muda para PAGA e os pagamentos são registrados em pdv_pagamento. Se cancelada, o status muda para CANCELADA e o estoque é devolvido.