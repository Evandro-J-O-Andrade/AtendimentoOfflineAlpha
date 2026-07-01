# runtime_api_session_token

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_token | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | varchar(36) | NOT NULL | - | (Documentar) |
| token_hash | varchar(255) | NOT NULL | - | (Documentar) |
| expira_em | datetime | NOT NULL | - | (Documentar) |
| device_id | varchar(100) | YES | - | (Documentar) |
| tenant_id | bigint | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| ultimo_acesso | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_runtime)

## Indices

- PRIMARY KEY (id_token)
- KEY (uuid_runtime)
- KEY (token_hash)
- KEY (id_usuario)
- KEY (expira_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

