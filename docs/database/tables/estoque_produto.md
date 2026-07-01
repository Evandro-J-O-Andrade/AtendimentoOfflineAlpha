# estoque_produto

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_produto | bigint | NO |  | id produto |
| id_codigo_universal | bigint | YES | NULL | id codigo universal |
| sku_interno | varchar(60) | NO |  | sku interno |
| barcode | varchar(60) | YES | NULL | barcode |
| nome | varchar(255) | NO |  | nome |
| descricao | text | YES |  | descricao |
| categoria | enum('MEDICAMENTO','MATERIAL','OPME','INSUMO','LABORATORIO','OUTRO') | NO |  | categoria |
| subcategoria | varchar(120) | YES | NULL | subcategoria |
| marca | varchar(120) | YES | NULL | marca |
| id_unidade_medida | binary(16) | NO |  | id unidade medida |
| exige_lote | tinyint(1) | NO | '1' | exige lote |
| controlado | tinyint(1) | NO | '0' | controlado |
| exige_receita | tinyint(1) | NO | '0' | exige receita |
| controlado_anvisa | tinyint(1) | NO | '0' | controlado anvisa |
| registro_anvisa | varchar(50) | YES | NULL | registro anvisa |
| curva_abc | enum('A','B','C') | YES | NULL | curva abc |
| estoque_minimo | decimal(15,4) | YES | NULL | estoque minimo |
| estoque_maximo | decimal(15,4) | YES | NULL | estoque maximo |
| ponto_reposicao | decimal(15,4) | YES | NULL | ponto reposicao |
| ativo | tinyint(1) | NO | '1' | ativo |
| id_sessao_usuario | bigint | NO |  | id sessao usuario |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: id_produto.
- Ãšnicas:
  - uk_sku (sku_interno)
  - uk_barcode (barcode)

## Ãndices

- fk_prod_sessao em (id_sessao_usuario)

## Constraints

- Nenhuma constraint adicional.

## Relacionamentos e Cardinalidade

- Nenhum relacionamento externo declarado.

## DependÃªncias

- Nenhuma dependÃªncia externa declarada.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

