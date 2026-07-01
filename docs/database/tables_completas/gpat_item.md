# gpat_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_gpat_item | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| id_farmaco | bigint | NOT NULL | - | (Documentar) |
| quantidade_total | decimal(10 | NOT NULL | - | (Documentar) |
| unidade_medida | varchar(20) | YES | - | (Documentar) |
| posologia | text | YES | - | (Documentar) |
| dias | int | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_farmaco -> farmaco.id_farmaco
- Estrangeira: id_gpat -> gpat_atendimento.id_gpat

## Indices

- PRIMARY KEY (id_gpat_item)
- KEY (id_gpat)
- KEY (id_farmaco)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

