# atendimento_triagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| escala_dor | int | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| peso | decimal(5 | YES | - | (Documentar) |
| altura | decimal(3 | YES | - | (Documentar) |
| pressao_arterial | varchar(20) | YES | - | (Documentar) |
| frequencia_cardiaca | int | YES | - | (Documentar) |
| temperatura | decimal(4 | YES | - | (Documentar) |
| saturacao | int | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| device_info | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id)
- KEY (id_ffa)
- KEY (id_atendimento)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

