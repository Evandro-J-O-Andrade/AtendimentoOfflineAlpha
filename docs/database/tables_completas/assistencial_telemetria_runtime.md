# assistencial_telemetria_runtime

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_telemetria | bigint | NOT NULL | - | (Documentar) |
| componente | varchar(60) | NOT NULL | - | (Documentar) |
| metrica | varchar(60) | NOT NULL | - | (Documentar) |
| valor | decimal(18 | NOT NULL | - | (Documentar) |
| unidade | varchar(30) | YES | - | (Documentar) |
| criticidade | enum('INFO' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_telemetria)
- KEY (componente,metrica,criado_em)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

