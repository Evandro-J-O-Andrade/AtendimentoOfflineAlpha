# administracao_medicacao_ordem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_administracao | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| realizado_em | datetime | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_aprazamento | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| status | enum('ADMINISTRADO' | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_item -> ordem_assistencial_item.id_item
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_administracao)
- KEY (id_item)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

