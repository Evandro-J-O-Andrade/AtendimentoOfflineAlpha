# kernel_authz_policy

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_policy | bigint | NOT NULL | - | (Documentar) |
| id_tenant | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| contexto | varchar(60) | NOT NULL | - | (Documentar) |
| recurso | varchar(120) | NOT NULL | - | (Documentar) |
| estado_origem | varchar(60) | YES | - | (Documentar) |
| estado_destino | varchar(60) | YES | - | (Documentar) |
| id_dispositivo | bigint | YES | - | (Documentar) |
| id_dispositivo_norm | bigint | YES | - | (Documentar) |
| permitido | tinyint | YES | - | (Documentar) |
| decision_fingerprint | char(64) | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_tenant,id_perfil,contexto,recurso,estado_origem,estado_destino,id_dispositivo_norm)

## Indices

- PRIMARY KEY (id_policy)
- KEY (id_tenant,id_perfil,contexto,recurso,estado_origem,estado_destino,id_dispositivo_norm)
- KEY (id_tenant,contexto,recurso,ativo,permitido)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

