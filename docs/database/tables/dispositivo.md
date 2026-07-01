# dispositivo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_dispositivo | bigint | NO |  | id dispositivo |
| identificador | varchar(120) | NO |  | identificador |
| descricao | varchar(120) | YES | NULL | descricao |
| tipo | varchar(50) | YES | NULL | tipo |
| ip_registro | varchar(45) | YES | NULL | ip registro |
| criado_em | datetime(6) | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_dispositivo.
- Ãšnicas:
  - uk_dispositivo_identificador (identificador)

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

