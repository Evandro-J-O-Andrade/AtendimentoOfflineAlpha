# estoque_produto

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_produto | bigint | NOT NULL | - | (Documentar) |
| id_codigo_universal | bigint | YES | - | (Documentar) |
| sku_interno | varchar(60) | NOT NULL | - | (Documentar) |
| barcode | varchar(60) | YES | - | (Documentar) |
| nome | varchar(255) | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| categoria | enum('MEDICAMENTO' | NOT NULL | - | (Documentar) |
| subcategoria | varchar(120) | YES | - | (Documentar) |
| marca | varchar(120) | YES | - | (Documentar) |
| id_unidade_medida | binary(16) | NOT NULL | - | (Documentar) |
| exige_lote | tinyint(1) | NOT NULL | - | (Documentar) |
| controlado | tinyint(1) | NOT NULL | - | (Documentar) |
| exige_receita | tinyint(1) | NOT NULL | - | (Documentar) |
| controlado_anvisa | tinyint(1) | NOT NULL | - | (Documentar) |
| registro_anvisa | varchar(50) | YES | - | (Documentar) |
| curva_abc | enum('A' | YES | - | (Documentar) |
| estoque_minimo | decimal(15 | YES | - | (Documentar) |
| estoque_maximo | decimal(15 | YES | - | (Documentar) |
| ponto_reposicao | decimal(15 | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (sku_interno)
- Unica: UNIQUE KEY (barcode)

## Indices

- PRIMARY KEY (id_produto)
- KEY (sku_interno)
- KEY (barcode)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

