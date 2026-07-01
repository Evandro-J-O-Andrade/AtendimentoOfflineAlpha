# consumo_limpeza

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_consumo | bigint | NOT NULL | - | (Documentar) |
| id_setor | int | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| unidade | varchar(20) | YES | - | (Documentar) |
| consumido_em | datetime | YES | - | (Documentar) |
| registrado_por | bigint | NOT NULL | - | (Documentar) |
| motivo | enum('ROTINA' | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_consumo)
- KEY (id_setor)
- KEY (id_produto)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

