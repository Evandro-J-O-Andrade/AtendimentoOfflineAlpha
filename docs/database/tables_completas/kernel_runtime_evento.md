# kernel_runtime_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | char(36) | NOT NULL | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| tipo_evento | varchar(80) | NOT NULL | - | (Documentar) |
| entidade_alvo | varchar(80) | YES | - | (Documentar) |
| id_referencia | bigint | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| hash_evento | char(64) | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (uuid_runtime)
- KEY (tipo_evento)
- KEY (entidade_alvo,id_referencia)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

