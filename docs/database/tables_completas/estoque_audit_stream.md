# estoque_audit_stream

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_audit | bigint | NOT NULL | - | (Documentar) |
| id_referencia_externa | bigint | YES | - | (Documentar) |
| entidade_tipo | enum('ESTOQUE' | NOT NULL | - | (Documentar) |
| evento_tipo | varchar(50) | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| hash_pipeline | char(64) | YES | - | (Documentar) |
| criado_em | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_audit)
- KEY (id_referencia_externa)
- KEY (hash_pipeline)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

