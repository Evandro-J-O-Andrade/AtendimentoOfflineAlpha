# runtime_invariant_log

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_invariant | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | char(36) | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| tipo_invariante | varchar(80) | NOT NULL | - | (Documentar) |
| payload_original | json | YES | - | (Documentar) |
| hash_payload | char(64) | NOT NULL | - | (Documentar) |
| estado_valido | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_invariant)
- KEY (uuid_runtime)
- KEY (estado_valido)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

