# prescricao_continua

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_prescricao | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('MEDICAMENTOS' | NOT NULL | - | (Documentar) |
| id_medico | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| ativa | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_medico -> medico.id_usuario

## Indices

- PRIMARY KEY (id_prescricao)
- KEY (id_atendimento)
- KEY (id_medico)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

