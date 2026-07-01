# estoque_lote

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_lote | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| numero_lote | varchar(100) | NOT NULL | - | (Documentar) |
| data_validade | date | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_item -> estoque_item.id_item

## Indices

- PRIMARY KEY (id_lote)
- KEY (id_item)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

