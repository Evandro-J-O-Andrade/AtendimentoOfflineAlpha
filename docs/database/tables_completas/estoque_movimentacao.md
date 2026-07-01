# estoque_movimentacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_movimentacao | bigint | NOT NULL | - | (Documentar) |
| id_saldo | bigint | NOT NULL | - | (Documentar) |
| tipo_movimento | enum('ENTRADA' | NOT NULL | - | (Documentar) |
| origem_modulo | enum('FARMACIA' | NOT NULL | - | (Documentar) |
| id_origem | bigint | YES | - | (Documentar) |
| quantidade | decimal(14 | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| confirmado | tinyint(1) | NOT NULL | - | (Documentar) |
| confirmado_em | datetime | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_saldo -> estoque_produto_saldo.id_saldo

## Indices

- PRIMARY KEY (id_movimentacao)
- KEY (id_saldo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

