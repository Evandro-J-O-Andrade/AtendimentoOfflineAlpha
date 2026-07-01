# estoque_conciliacao_atomica

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_movimento | bigint | NOT NULL | - | (Documentar) |
| id_movimento_item | bigint | NOT NULL | - | (Documentar) |
| id_ledger | bigint | NOT NULL | - | (Documentar) |
| id_fluxo_assistencial | bigint | YES | - | (Documentar) |
| hash_execucao | char(64) | NOT NULL | - | (Documentar) |
| estado_conciliacao | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| divergencia_quantidade | decimal(10 | YES | - | (Documentar) |
| divergencia_valor | decimal(10 | YES | - | (Documentar) |
| validado_em | datetime | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_movimento_item)
- Unica: UNIQUE KEY (hash_execucao)

## Indices

- PRIMARY KEY (id)
- KEY (id_movimento_item)
- KEY (hash_execucao)
- KEY (id_movimento)
- KEY (id_fluxo_assistencial)
- KEY (estado_conciliacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

