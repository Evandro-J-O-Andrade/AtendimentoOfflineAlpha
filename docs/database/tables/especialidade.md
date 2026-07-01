# especialidade

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_especialidade | bigint | NO |  | id especialidade |
| nome | varchar(150) | NO |  | nome |
| cbo | varchar(10) | YES | NULL | cbo |
| ativo | tinyint | YES | '1' | ativo |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP | criado em |
| atualizado_em | datetime(6) | YES | NULL | atualizado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_especialidade.
- Ãšnicas:
  - nome (nome)

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

