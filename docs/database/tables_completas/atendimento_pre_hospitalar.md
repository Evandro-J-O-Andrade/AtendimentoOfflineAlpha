# atendimento_pre_hospitalar

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pre_hospitalar | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| tipo_intervencao | enum('SAMU' | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| inicio_em | datetime(6) | YES | - | (Documentar) |
| fim_em | datetime(6) | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_atendimento -> atendimento.id_atendimento

## Indices

- PRIMARY KEY (id_pre_hospitalar)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

