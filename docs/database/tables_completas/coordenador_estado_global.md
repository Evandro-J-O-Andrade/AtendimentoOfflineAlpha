# coordenador_estado_global

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_coordenacao | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | char(36) | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| estado_atual | varchar(80) | NOT NULL | - | (Documentar) |
| hash_estado | char(64) | NOT NULL | - | (Documentar) |
| payload_snapshot | json | YES | - | (Documentar) |
| bloqueado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_coordenacao)
- KEY (uuid_runtime)
- KEY (estado_atual)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

