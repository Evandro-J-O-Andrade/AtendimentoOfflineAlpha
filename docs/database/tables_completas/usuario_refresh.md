# usuario_refresh

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_refresh | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| token_hash | char(64) | NOT NULL | - | (Documentar) |
| expires_at | datetime | NOT NULL | - | (Documentar) |
| created_at | datetime | NOT NULL | - | (Documentar) |
| revoked | tinyint(1) | NOT NULL | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| ip | varchar(45) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (token_hash)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_refresh)
- KEY (token_hash)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

