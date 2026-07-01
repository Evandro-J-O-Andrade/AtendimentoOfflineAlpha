# atendimento_recepcao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| tipo_atendimento | enum('CLINICO' | NOT NULL | - | (Documentar) |
| chegada | enum('MEIOS_PROPRIOS' | NOT NULL | - | (Documentar) |
| prioridade | enum('AUTISTA' | YES | - | (Documentar) |
| motivo_procura | text | YES | - | (Documentar) |
| destino_inicial | enum('TRIAGEM' | NOT NULL | - | (Documentar) |
| id_recepcionista | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_recepcionista -> usuario.id_usuario
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_atendimento)
- KEY (id_recepcionista)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

