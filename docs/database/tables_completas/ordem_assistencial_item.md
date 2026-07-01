# ordem_assistencial_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_ordem | bigint | NOT NULL | - | (Documentar) |
| tipo_item | enum('FARMACO' | NOT NULL | - | (Documentar) |
| id_farmaco | bigint | YES | - | (Documentar) |
| descricao_item | varchar(255) | YES | - | (Documentar) |
| dose | varchar(100) | YES | - | (Documentar) |
| via | varchar(50) | YES | - | (Documentar) |
| posologia | varchar(100) | YES | - | (Documentar) |
| dias | int | YES | - | (Documentar) |
| quantidade | decimal(10 | YES | - | (Documentar) |
| unidade | varchar(20) | YES | - | (Documentar) |
| frequencia_min | int | YES | - | (Documentar) |
| frequencia_txt | varchar(50) | YES | - | (Documentar) |
| horarios_json | json | YES | - | (Documentar) |
| inicio_em | datetime | YES | - | (Documentar) |
| fim_em | datetime | YES | - | (Documentar) |
| quantidade_total | decimal(10 | NOT NULL | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_por | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario_criado | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_por | bigint | YES | - | (Documentar) |
| id_sessao_usuario_atualizado | bigint | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_farmaco -> farmaco.id_farmaco
- Estrangeira: id_ordem -> ordem_assistencial.id
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_item)
- KEY (id_ordem)
- KEY (id_farmaco)
- KEY (tipo_item,status)
- KEY (id_ordem,status)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

