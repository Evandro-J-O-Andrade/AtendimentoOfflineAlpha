# estoque_conta

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_conta | bigint | NO |  | id conta |
| codigo | varchar(30) | NO |  | codigo |
| descricao | varchar(150) | NO |  | descricao |
| tipo | enum('FISICO','RESERVA','PERDA','AJUSTE','TRANSITO','CONSUMO_ASSISTENCIAL') | NO |  | tipo |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_conta.
- Ãšnicas:
  - codigo (codigo)

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

