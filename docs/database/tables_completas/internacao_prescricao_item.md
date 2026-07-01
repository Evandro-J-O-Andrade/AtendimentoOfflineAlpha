# internacao_prescricao_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_prescricao_item | bigint | NOT NULL | - | (Documentar) |
| id_internacao_prescricao | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('MEDICAMENTO' | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| dosagem | varchar(60) | YES | - | (Documentar) |
| frequencia | varchar(60) | YES | - | (Documentar) |
| via_administracao | varchar(60) | YES | - | (Documentar) |
| inicio_em | datetime | YES | - | (Documentar) |
| fim_em | datetime | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| observacoes | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_internacao_prescricao -> internacao_prescricao.id_internacao_prescricao

## Indices

- PRIMARY KEY (id_internacao_prescricao_item)
- KEY (id_internacao_prescricao)
- KEY (tipo)
- KEY (status)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

