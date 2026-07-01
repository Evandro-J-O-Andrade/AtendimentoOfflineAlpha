# atendimento_identidade_fluxo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_fluxo | bigint | NOT NULL | - | (Documentar) |
| uuid_evento | char(36) | NOT NULL | - | (Documentar) |
| uuid_pessoa_assistida | char(36) | NOT NULL | - | (Documentar) |
| tipo_entidade | enum('PACIENTE' | NOT NULL | - | (Documentar) |
| origem_cadastro | enum('CENTRAL' | NOT NULL | - | (Documentar) |
| metadata_fluxo | json | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_evento)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_fluxo)
- KEY (uuid_evento)
- KEY (uuid_pessoa_assistida)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

