# usuario_refresh_token

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_token | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| token | varchar(255) | NOT NULL | - | (Documentar) |
| expira_em | datetime | NOT NULL | - | (Documentar) |
| revogado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (token)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_token)
- KEY (token)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

