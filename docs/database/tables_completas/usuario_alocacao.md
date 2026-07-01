# usuario_alocacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_alocacao | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sala | int | NOT NULL | - | (Documentar) |
| id_especialidade | bigint | YES | - | (Documentar) |
| inicio | datetime | NOT NULL | - | (Documentar) |
| fim | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_especialidade -> especialidade.id_especialidade
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_alocacao)
- KEY (id_usuario)
- KEY (id_especialidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

