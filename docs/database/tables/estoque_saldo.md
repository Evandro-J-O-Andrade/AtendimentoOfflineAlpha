# estoque_saldo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_saldo | bigint | NO |  | id saldo |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_local | bigint | NO |  | id local |
| contexto_tipo | enum('CENTRAL','FARMACIA','ASSISTENCIAL','LEITO','UTI','FATURAMENTO') | NO |  | contexto tipo |
| id_item | bigint | NO |  | id item |
| id_lote | bigint | NO |  | id lote |
| qtd_fisica | decimal(15,4) | NO | '0.0000' | qtd fisica |
| qtd_reservada | decimal(15,4) | NO | '0.0000' | qtd reservada |
| qtd_projetada | decimal(15,4) | YES |  | qtd projetada |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| ultima_atualizacao | timestamp | YES | CURRENT_TIMESTAMP | ultima atualizacao |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_saldo.
- Estrangeiras:
  - id_unidade referencia unidade.id_unidade

## Ãndices

- Nenhum Ã­ndice adicional.

## Constraints

- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- estoque_saldo (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

