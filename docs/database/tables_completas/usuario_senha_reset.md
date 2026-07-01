# usuario_senha_reset

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_senha_reset | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| token_hash | varchar(64) | NOT NULL | - | (Documentar) |
| expira_em | datetime | NOT NULL | - | (Documentar) |
| usado_em | datetime | YES | - | (Documentar) |
| id_sessao_usuario_solicitante | bigint | YES | - | (Documentar) |
| id_usuario_solicitante | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (token_hash)
- Estrangeira: id_usuario_solicitante -> usuario.id_usuario
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_usuario_senha_reset)
- KEY (token_hash)
- KEY (id_usuario)
- KEY (expira_em)
- KEY (id_sessao_usuario_solicitante)
- KEY (id_usuario_solicitante)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

