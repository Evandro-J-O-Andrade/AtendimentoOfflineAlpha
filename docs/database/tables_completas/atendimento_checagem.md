# atendimento_checagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_prescricao | bigint | NOT NULL | - | (Documentar) |
| horario_planejado | datetime | NOT NULL | - | (Documentar) |
| horario_executado | datetime | YES | - | (Documentar) |
| id_enfermeiro | bigint | YES | - | (Documentar) |
| status | enum('PENDENTE' | YES | - | (Documentar) |
| motivo_recusa | varchar(255) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_prescricao -> atendimento_prescricao.id

## Indices

- PRIMARY KEY (id)
- KEY (id_prescricao)
- KEY (horario_planejado,status)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

