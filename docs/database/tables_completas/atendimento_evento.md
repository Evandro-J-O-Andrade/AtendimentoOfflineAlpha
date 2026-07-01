# atendimento_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| dominio | varchar(40) | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(60) | NOT NULL | - | (Documentar) |
| estado_origem | varchar(40) | YES | - | (Documentar) |
| estado_destino | varchar(40) | YES | - | (Documentar) |
| contexto_fluxo | varchar(60) | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| hash_evento | char(64) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_ffa)
- KEY (id_atendimento)
- KEY (id_paciente)
- KEY (dominio)
- KEY (tipo_evento)
- KEY (criado_em)
- KEY (id_sessao_usuario)
- KEY (hash_evento)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

