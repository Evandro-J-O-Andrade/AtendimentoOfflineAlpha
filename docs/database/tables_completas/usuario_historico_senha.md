# usuario_historico_senha

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_historico | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| senha_hash | varchar(255) | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_historico)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

