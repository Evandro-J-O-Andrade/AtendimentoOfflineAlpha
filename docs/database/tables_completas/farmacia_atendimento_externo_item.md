# farmacia_atendimento_externo_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_farmaco | bigint | NOT NULL | - | (Documentar) |
| quantidade_total | decimal(10 | NOT NULL | - | (Documentar) |
| posologia | text | YES | - | (Documentar) |
| dias | int | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| criado_por | bigint | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| atualizado_por | bigint | YES | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| id_local_estoque | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> farmacia_atendimento_externo.id_atendimento
- Estrangeira: id_farmaco -> farmaco.id_farmaco

## Indices

- PRIMARY KEY (id_item)
- KEY (id_atendimento,status)
- KEY (id_farmaco)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

