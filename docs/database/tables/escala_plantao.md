# escala_plantao

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_escala | bigint | NO |  | id escala |
| id_unidade | bigint unsigned | NO |  | id unidade |
| id_sistema | bigint | NO |  | id sistema |
| data | date | NO |  | data |
| id_plantao_modelo | bigint | NO |  | id plantao modelo |
| observacao | varchar(255) | YES | NULL | observacao |
| criado_em | datetime | YES | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_escala.
- Estrangeiras:
  - id_plantao_modelo referencia plantao_modelo.id_plantao_modelo
  - id_sistema referencia sistema.id_sistema
  - id_unidade referencia unidade.id_unidade

## Ãndices

- fk_esc_sistema em (id_sistema)
- fk_esc_pm em (id_plantao_modelo)

## Constraints

- FOREIGN KEY (id_plantao_modelo) REFERENCES plantao_modelo(id_plantao_modelo)
- FOREIGN KEY (id_sistema) REFERENCES sistema(id_sistema)
- FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)

## Relacionamentos e Cardinalidade

- escala_plantao (id_plantao_modelo) -> plantao_modelo (id_plantao_modelo): N:1
- escala_plantao (id_sistema) -> sistema (id_sistema): N:1
- escala_plantao (id_unidade) -> unidade (id_unidade): N:1

## DependÃªncias

- Depende de: plantao_modelo, sistema, unidade.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

