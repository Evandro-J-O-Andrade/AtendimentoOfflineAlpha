# runtime_snapshot_metadata

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_snapshot | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| versao_fluxo | bigint | NOT NULL | - | (Documentar) |
| hash_snapshot | char(64) | NOT NULL | - | (Documentar) |
| payload_metadata | json | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| expiracao_snapshot | datetime(6) | NOT NULL | - | (Documentar) |
| ultima_validacao_runtime | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_snapshot)

## Indices

- PRIMARY KEY (id_snapshot)
- KEY (hash_snapshot)
- KEY (dominio_fluxo,versao_fluxo)
- KEY (expiracao_snapshot)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

