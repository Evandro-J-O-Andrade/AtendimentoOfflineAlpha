# runtime_concurrency_guard

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_guard | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| id_recurso | varchar(100) | NOT NULL | - | (Documentar) |
| versao_estado | bigint | NOT NULL | - | (Documentar) |
| token_execucao | char(36) | NOT NULL | - | (Documentar) |
| hash_contexto | char(64) | NOT NULL | - | (Documentar) |
| status_guard | enum('PROVISIONAL' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| confirmado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (dominio_fluxo,id_recurso,versao_estado,token_execucao)

## Indices

- PRIMARY KEY (id_guard)
- KEY (dominio_fluxo,id_recurso,versao_estado,token_execucao)
- KEY (status_guard)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

