# farmacia_dispensacao_log

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_prescricao_item | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_lote | bigint | YES | - | (Documentar) |
| quantidade | decimal(14 | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_lote -> lote.id
- Estrangeira: id_prescricao_item -> prescricao_item.id_item
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario

## Indices

- PRIMARY KEY (id)
- KEY (id_prescricao_item)
- KEY (id_sessao_usuario)
- KEY (criado_em)
- KEY (id_lote)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

