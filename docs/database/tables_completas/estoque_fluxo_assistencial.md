# estoque_fluxo_assistencial

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_paciente | bigint | NOT NULL | - | (Documentar) |
| id_ffaitem | bigint | NOT NULL | - | (Documentar) |
| id_movimento | bigint | NOT NULL | - | (Documentar) |
| id_movimento_item | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | NOT NULL | - | (Documentar) |
| hash_execucao | char(64) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_ffaitem,id_movimento_item)
- Unica: UNIQUE KEY (hash_execucao)

## Indices

- PRIMARY KEY (id)
- KEY (id_ffaitem,id_movimento_item)
- KEY (hash_execucao)
- KEY (id_paciente)
- KEY (id_lote)
- KEY (id_produto)
- KEY (id_movimento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

