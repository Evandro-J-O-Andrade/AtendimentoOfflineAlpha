# erro_catalogo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_erro_catalogo | bigint | NO |  | id erro catalogo |
| codigo | varchar(20) | NO |  | codigo |
| dominio | varchar(50) | NO |  | dominio |
| descricao | varchar(255) | NO |  | descricao |
| ativo | tinyint(1) | NO | '1' | ativo |
| criado_em | datetime(6) | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | YES | NULL | id entidade |

## Chaves

- PrimÃ¡ria: id_erro_catalogo.
- Ãšnicas:
  - codigo (codigo)

## Ãndices

- idx_erro_catalogo_dominio em (dominio)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

