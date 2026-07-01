# estoque_saldo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_saldo | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | NOT NULL | - | (Documentar) |
| contexto_tipo | enum('CENTRAL' | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| qtd_fisica | decimal(15 | NOT NULL | - | (Documentar) |
| qtd_reservada | decimal(15 | NOT NULL | - | (Documentar) |
| qtd_projetada | decimal(15 | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| ultima_atualizacao | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_unidade,id_local,id_item,id_lote)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_saldo)
- KEY (id_unidade,id_local,id_item,id_lote)
- KEY (id_item,id_local,id_lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

