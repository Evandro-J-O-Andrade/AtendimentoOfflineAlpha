# runtime_lock_semantico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_lock | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| id_recurso | varchar(100) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| token_lock | char(36) | NOT NULL | - | (Documentar) |
| expiracao_lock | datetime(6) | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (dominio_fluxo,id_recurso)

## Indices

- PRIMARY KEY (id_lock)
- KEY (dominio_fluxo,id_recurso)
- KEY (expiracao_lock)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

