# guardiao_acl_runtime

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_guardiao_acl | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| contexto | varchar(60) | NOT NULL | - | (Documentar) |
| recurso | varchar(120) | NOT NULL | - | (Documentar) |
| permitido | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_guardiao_acl)
- KEY (id_usuario)
- KEY (contexto)
- KEY (recurso)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

