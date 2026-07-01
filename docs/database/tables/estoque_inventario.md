# estoque_inventario

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_inventario | bigint | NO |  | id inventario |
| id_estoque_local | bigint | NO |  | id estoque local |
| id_codigo_universal | bigint | YES | NULL | id codigo universal |
| codigo | varchar(60) | YES | NULL | codigo |
| barcode | varchar(60) | YES | NULL | barcode |
| status | enum('ABERTO','EM_CONTAGEM','FECHADO','CANCELADO') | NO | 'ABERTO' | status |
| id_sessao_usuario_abertura | bigint | NO |  | id sessao usuario abertura |
| aberto_em | datetime | NO | CURRENT_TIMESTAMP | aberto em |
| fechado_em | datetime | YES | NULL | fechado em |
| observacao | varchar(255) | YES | NULL | observacao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_inventario.

## Ãndices

- ix_inv_local em (id_estoque_local)
- ix_inv_status em (status)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

