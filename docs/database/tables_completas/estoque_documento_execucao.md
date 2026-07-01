# estoque_documento_execucao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| hash_execucao | char(64) | NOT NULL | - | (Documentar) |
| id_documento | bigint | NOT NULL | - | (Documentar) |
| tipo_documento | varchar(50) | NOT NULL | - | (Documentar) |
| id_movimento | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| contexto_operacional | varchar(100) | YES | - | (Documentar) |
| estado_execucao | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| tentativa_execucao | int | NOT NULL | - | (Documentar) |
| hash_pipeline_anterior | char(64) | YES | - | (Documentar) |
| hash_pipeline_atual | char(64) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_execucao)
- Unica: UNIQUE KEY (id_documento,tipo_documento)

## Indices

- PRIMARY KEY (id)
- KEY (hash_execucao)
- KEY (id_documento,tipo_documento)
- KEY (id_documento)
- KEY (id_movimento)
- KEY (id_sessao_usuario)
- KEY (estado_execucao)
- KEY (hash_pipeline_atual)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

