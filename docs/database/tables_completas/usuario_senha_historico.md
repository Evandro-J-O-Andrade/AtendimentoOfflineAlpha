# usuario_senha_historico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_senha_hist | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| hash_formato | varchar(255) | NOT NULL | - | (Documentar) |
| motivo | enum('CRIACAO' | NOT NULL | - | (Documentar) |
| detalhe | varchar(4000) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario_executor | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario_executor -> usuario.id_usuario
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_usuario_senha_hist)
- KEY (id_usuario,criado_em)
- KEY (motivo,criado_em)
- KEY (id_sessao_usuario)
- KEY (id_usuario_executor)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

