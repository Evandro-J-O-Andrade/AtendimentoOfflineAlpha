# pdv_cliente

Objetivo: Armazenar clientes para o Ponto de Venda (PDV).
Descrição: Tabela que mantém o cadastro de clientes que utilizam o PDV do sistema, armazenando nome, documento, contato e informações para emissão de notas fiscais e atendimento.

## Colunas
| Coluna | Tipo | Nullable | Default | Função/Descrição |
|--------|------|----------|---------|------------------|
| id_cliente | bigint | NOT NULL | - | Identificador único do cliente (chave primária, auto incremento) |
| nome | varchar(255) | NOT NULL | - | Nome completo do cliente |
| documento | varchar(30) | YES | NULL | Documento do cliente (CPF ou CNPJ) |
| telefone | varchar(40) | YES | NULL | Telefone de contato do cliente |
| email | varchar(120) | YES | NULL | Email de contato do cliente |
| criado_em | datetime | NOT NULL | CURRENT_TIMESTAMP | Data/hora de cadastro do cliente |
| id_entidade | bigint unsigned | NOT NULL | - | ID da entidade/tenant à qual o cliente pertence |

## Chaves
- Primária: id_cliente
- Únicas: (nenhuma)
- Estrangeiras: (nenhuma foreign key)

## Índices
- PRIMARY KEY (id_cliente)
- KEY ix_cliente_doc (documento)

## Constraints
- PRIMARY KEY: id_cliente

## Relacionamentos e Cardinalidade
- 1:N com pdv_venda: Um cliente pode ter muitas vendas no PDV
- N:1 com saas_entidade: Muitos clientes pertencem a uma entidade

## Dependências
- Esta tabela depende de: saas_entidade
- Tabelas que dependem desta: pdv_venda

## Fluxo de utilização dentro do sistema
Utilizada para cadastrar clientes que realizam compras no PDV. Ao iniciar uma venda, pode-se associar um cliente existente ou cadastrar novo. O documento é utilizado para emissão de nota fiscal. Permite manter histórico de compras por cliente e facilitar busca por documento ou nome.