# auth_token

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_token | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo_token | enum('ACCESS' | NOT NULL | - | (Documentar) |
| token_hash | varchar(255) | NOT NULL | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | text | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| expira_em | datetime | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| utilizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_token)
- KEY (id_usuario)
- KEY (token_hash)
- KEY (expira_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

