# ffa_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_ffa_item | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_paciente | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| dose_prescrita | decimal(15 | NOT NULL | - | (Documentar) |
| unidade_prescrita | varchar(20) | NOT NULL | - | (Documentar) |
| quantidade_autorizada | decimal(15 | NOT NULL | - | (Documentar) |
| quantidade_dispensada | decimal(15 | NOT NULL | - | (Documentar) |
| status | enum('PRESCRITO' | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_produto -> estoque_produto.id_produto

## Indices

- PRIMARY KEY (id_ffa_item)
- KEY (id_produto)
- KEY (id_sessao_usuario)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

