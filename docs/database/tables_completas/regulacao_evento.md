# regulacao_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_regulacao | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| status | enum('SOLICITADO' | NOT NULL | - | (Documentar) |
| destino_unidade | bigint | YES | - | (Documentar) |
| tipo_regulacao | varchar(50) | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_ffa -> ffa.id_ffa
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_regulacao)
- KEY (id_ffa)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

