# ordem_assistencial_execucao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_execucao | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_aprazamento | bigint | YES | - | (Documentar) |
| acao | enum('REALIZADO' | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | YES | - | (Documentar) |
| realizado_em | datetime | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_aprazamento -> ordem_assistencial_aprazamento.id_aprazamento
- Estrangeira: id_item -> ordem_assistencial_item.id_item
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_execucao)
- KEY (id_item,realizado_em)
- KEY (id_aprazamento)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

