# estoque_movimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_movimento | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_origem | bigint | YES | - | (Documentar) |
| id_local_destino | bigint | YES | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| tipo_movimento | enum('ENTRADA' | NOT NULL | - | (Documentar) |
| quantidade | decimal(15 | NOT NULL | - | (Documentar) |
| hash_duplicidade | char(64) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_duplicidade)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_item -> estoque_item.id_item
- Estrangeira: id_lote -> estoque_lote.id_lote

## Indices

- PRIMARY KEY (id_movimento)
- KEY (hash_duplicidade)
- KEY (id_item)
- KEY (id_lote)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

