# saas_contrato

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_contrato | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| data_inicio | date | NOT NULL | - | (Documentar) |
| data_fim | date | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_contrato)
- KEY (id_entidade,status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

