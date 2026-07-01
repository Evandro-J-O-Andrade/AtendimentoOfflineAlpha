# ffa_evolucao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evolucao | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| texto | longtext | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| tipo | varchar(30) | NOT NULL | - | (Documentar) |
| modulo | varchar(60) | YES | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| ip | varchar(60) | YES | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| hash_integridade | varchar(64) | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_evolucao)
- KEY (id_ffa)
- KEY (id_sessao_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

