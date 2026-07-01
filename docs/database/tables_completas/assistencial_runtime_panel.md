# assistencial_runtime_panel

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_panel | bigint | NOT NULL | - | (Documentar) |
| health_score_runtime | decimal(10 | YES | - | (Documentar) |
| backlog_federado | int | YES | - | (Documentar) |
| retry_rate | decimal(10 | YES | - | (Documentar) |
| hash_hit_rate | decimal(10 | YES | - | (Documentar) |
| tombstone_hit_rate | decimal(10 | YES | - | (Documentar) |
| divergencia_edge_nucleo | decimal(10 | YES | - | (Documentar) |
| estado_runtime | varchar(60) | YES | - | (Documentar) |
| alerta_preventivo | varchar(120) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_panel)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_panel)
- KEY (id_panel)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

