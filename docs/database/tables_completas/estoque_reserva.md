# estoque_reserva

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_reserva | bigint | NOT NULL | - | (Documentar) |
| id_estoque_local | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | NOT NULL | - | (Documentar) |
| quantidade | decimal(15 | NOT NULL | - | (Documentar) |
| origem_tipo | enum('FARM_DISP' | NOT NULL | - | (Documentar) |
| id_documento_origem | bigint | YES | - | (Documentar) |
| status | enum('ATIVA' | NOT NULL | - | (Documentar) |
| hash_anterior | char(64) | YES | - | (Documentar) |
| hash_atual | char(64) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_estoque_local -> estoque_local.id_estoque_local
- Estrangeira: id_lote -> estoque_lote.id_lote
- Estrangeira: id_produto -> estoque_produto.id_produto

## Indices

- PRIMARY KEY (id_reserva)
- KEY (id_estoque_local)
- KEY (id_produto)
- KEY (id_lote)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

