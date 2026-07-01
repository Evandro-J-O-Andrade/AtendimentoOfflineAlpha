# farmacia_atendimento_externo_dispensacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_dispensacao | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| id_local_estoque | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| status | enum('ENTREGUE' | NOT NULL | - | (Documentar) |
| dispensado_em | datetime | NOT NULL | - | (Documentar) |
| dispensado_por | bigint | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_item -> farmacia_atendimento_externo_item.id_item
- Estrangeira: id_local_estoque -> local_atendimento.id_local
- Estrangeira: id_lote -> farmaco_lote.id_lote
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_dispensacao)
- KEY (id_item,status)
- KEY (id_lote)
- KEY (id_local_estoque)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

