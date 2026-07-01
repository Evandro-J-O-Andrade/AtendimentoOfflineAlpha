# prescricao_kit_itens

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | int | NOT NULL | - | (Documentar) |
| id_kit | int | NOT NULL | - | (Documentar) |
| item_nome | varchar(255) | NOT NULL | - | (Documentar) |
| dose | varchar(50) | YES | - | (Documentar) |
| via | varchar(20) | YES | - | (Documentar) |
| frequencia | varchar(50) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_kit -> prescricao_kit_master.id

## Indices

- PRIMARY KEY (id)
- KEY (id_kit)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

