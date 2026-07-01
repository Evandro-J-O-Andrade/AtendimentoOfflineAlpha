# local_fila

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_local_fila | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | NOT NULL | - | (Documentar) |
| codigo_fila | varchar(40) | YES | - | (Documentar) |
| nome_fila | varchar(120) | YES | - | (Documentar) |
| prioridade | int | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_local -> local.id_local

## Indices

- PRIMARY KEY (id_local_fila)
- KEY (id_local)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

