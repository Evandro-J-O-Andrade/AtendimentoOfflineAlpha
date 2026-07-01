# gpat_dispensacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_gpat_dispensacao | bigint | NOT NULL | - | (Documentar) |
| id_gpat_item | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| id_local_estoque | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| status | enum('ENTREGUE' | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| entregue_em | datetime | NOT NULL | - | (Documentar) |
| estornado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_gpat_item -> gpat_item.id_gpat_item
- Estrangeira: id_local_estoque -> local_atendimento.id_local
- Estrangeira: id_lote -> farmaco_lote.id_lote
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_gpat_dispensacao)
- KEY (id_gpat_item)
- KEY (id_lote)
- KEY (status)
- KEY (id_usuario)
- KEY (id_sessao_usuario)
- KEY (id_local_estoque)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

