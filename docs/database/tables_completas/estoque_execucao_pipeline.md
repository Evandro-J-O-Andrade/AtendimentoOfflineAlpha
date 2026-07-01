# estoque_execucao_pipeline

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| pipeline_hash | char(64) | NOT NULL | - | (Documentar) |
| estado | enum('PROCESSANDO' | NOT NULL | - | (Documentar) |
| lease_expira_em | timestamp | NOT NULL | - | (Documentar) |
| criado_em | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (pipeline_hash)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

