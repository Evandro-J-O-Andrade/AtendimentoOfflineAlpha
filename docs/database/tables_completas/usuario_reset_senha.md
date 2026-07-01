# usuario_reset_senha

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_reset | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| token_hash | varchar(255) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| expira_em | datetime | NOT NULL | - | (Documentar) |
| usado_em | datetime | YES | - | (Documentar) |
| ip_solicitacao | varchar(45) | YES | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_reset)
- KEY (id_usuario)
- KEY (expira_em)
- KEY (token_hash)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

