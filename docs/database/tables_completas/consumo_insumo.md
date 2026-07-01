# consumo_insumo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_consumo | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| origem | enum('FARMACIA' | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| usado_em | datetime | YES | - | (Documentar) |
| registrado_por | bigint | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_consumo)
- KEY (id_ffa)
- KEY (origem)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

