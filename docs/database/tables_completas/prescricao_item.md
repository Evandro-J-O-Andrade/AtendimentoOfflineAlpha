# prescricao_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_prescricao | bigint | NOT NULL | - | (Documentar) |
| descricao | text | NOT NULL | - | (Documentar) |
| dose | varchar(100) | YES | - | (Documentar) |
| via | varchar(50) | YES | - | (Documentar) |
| posologia | varchar(100) | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_lote | bigint | YES | - | (Documentar) |
| dispensado_em | datetime(6) | YES | - | (Documentar) |
| id_usuario_dispensacao | bigint | YES | - | (Documentar) |
| status | varchar(20) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_prescricao -> prescricao_continua.id_prescricao

## Indices

- PRIMARY KEY (id_item)
- KEY (id_prescricao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

