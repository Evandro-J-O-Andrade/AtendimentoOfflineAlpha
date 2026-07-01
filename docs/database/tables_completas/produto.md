# produto

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_produto | bigint | NOT NULL | - | (Documentar) |
| tipo_produto | varchar(40) | NOT NULL | - | (Documentar) |
| categoria | varchar(120) | YES | - | (Documentar) |
| subcategoria | varchar(120) | YES | - | (Documentar) |
| nome | varchar(255) | NOT NULL | - | (Documentar) |
| descricao_tecnica | text | YES | - | (Documentar) |
| unidade_medida | varchar(20) | YES | - | (Documentar) |
| controla_lote | tinyint | YES | - | (Documentar) |
| controla_validade | tinyint | YES | - | (Documentar) |
| controla_serial | tinyint | YES | - | (Documentar) |
| exige_prescricao | tinyint | YES | - | (Documentar) |
| codigo_barras | varchar(100) | YES | - | (Documentar) |
| codigo_interno | varchar(100) | YES | - | (Documentar) |
| codigo_sigtap | varchar(50) | YES | - | (Documentar) |
| codigo_gpat | varchar(50) | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_produto)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

