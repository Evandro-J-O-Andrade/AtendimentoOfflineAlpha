# ordem_assistencial

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| tipo_ordem | varchar(50) | NOT NULL | - | (Documentar) |
| status | enum('ATIVA' | NOT NULL | - | (Documentar) |
| origem | enum('MEDICO' | NOT NULL | - | (Documentar) |
| payload_clinico | json | NOT NULL | - | (Documentar) |
| prioridade | int | YES | - | (Documentar) |
| iniciado_em | datetime | YES | - | (Documentar) |
| suspenso_em | datetime | YES | - | (Documentar) |
| encerrado_em | datetime | YES | - | (Documentar) |
| motivo_suspensao | varchar(255) | YES | - | (Documentar) |
| motivo_encerramento | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| criado_por | bigint | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| atualizado_por | bigint | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id)
- KEY (id_ffa)
- KEY (status)
- KEY (tipo_ordem)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

