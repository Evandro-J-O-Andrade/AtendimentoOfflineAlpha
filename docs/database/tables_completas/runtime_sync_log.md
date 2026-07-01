# runtime_sync_log

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sync | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| uuid_evento | char(36) | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(60) | NOT NULL | - | (Documentar) |
| estado_payload | json | YES | - | (Documentar) |
| hash_payload | char(64) | YES | - | (Documentar) |
| sincronizado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_sync)
- KEY (id_unidade)
- KEY (uuid_evento)
- KEY (sincronizado)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

