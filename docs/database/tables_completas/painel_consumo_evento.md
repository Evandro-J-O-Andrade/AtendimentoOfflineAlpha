# painel_consumo_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_consumo | bigint | NOT NULL | - | (Documentar) |
| origem | enum('SENHA_EVENTOS' | NOT NULL | - | (Documentar) |
| id_evento | bigint | NOT NULL | - | (Documentar) |
| painel_tipo | varchar(50) | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| consumido_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (origem,id_evento,painel_tipo)

## Indices

- PRIMARY KEY (id_consumo)
- KEY (origem,id_evento,painel_tipo)
- KEY (id_local_operacional,consumido_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

