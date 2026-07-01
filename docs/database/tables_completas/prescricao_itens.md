# prescricao_itens

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_usuario_prescritor | bigint | NOT NULL | - | (Documentar) |
| tipo_item | enum('MEDICAMENTO' | YES | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| posologia_detalhada | text | YES | - | (Documentar) |
| frequencia_horario | varchar(100) | YES | - | (Documentar) |
| via_administracao | varchar(50) | YES | - | (Documentar) |
| observacao_enfermagem | text | YES | - | (Documentar) |
| data_inicio | datetime | YES | - | (Documentar) |
| data_suspensao | datetime | YES | - | (Documentar) |
| status | enum('ATIVO' | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento,tipo_item)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

