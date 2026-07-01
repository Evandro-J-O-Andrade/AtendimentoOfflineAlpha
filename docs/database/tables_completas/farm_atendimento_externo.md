# farm_atendimento_externo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_atendimento_ext | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| origem | varchar(120) | NOT NULL | - | (Documentar) |
| nome_paciente | varchar(255) | NOT NULL | - | (Documentar) |
| nome_medico | varchar(255) | NOT NULL | - | (Documentar) |
| conselho_medico | varchar(10) | YES | - | (Documentar) |
| numero_conselho | varchar(30) | YES | - | (Documentar) |
| uf_conselho | char(2) | YES | - | (Documentar) |
| data_receita | date | YES | - | (Documentar) |
| dias_tratamento | int | YES | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_atendimento_ext)
- KEY (id_gpat)
- KEY (status)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

