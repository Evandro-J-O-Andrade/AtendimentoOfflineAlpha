# sessao_usuario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| uuid_sessao | char(36) | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | YES | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| id_sala | bigint | YES | - | (Documentar) |
| id_dispositivo | bigint | YES | - | (Documentar) |
| token_jwt | varchar(512) | NOT NULL | - | (Documentar) |
| refresh_token | varchar(512) | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| iniciado_em | datetime(6) | NOT NULL | - | (Documentar) |
| expira_em | datetime(6) | NOT NULL | - | (Documentar) |
| contexto_definido_em | datetime(6) | YES | - | (Documentar) |
| finalizado_em | datetime(6) | YES | - | (Documentar) |
| motivo_finalizacao | varchar(120) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| revogado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| ip_country | varchar(80) | YES | - | (Documentar) |
| ip_city | varchar(120) | YES | - | (Documentar) |
| token_hash | varchar(128) | YES | - | (Documentar) |
| refresh_hash | varchar(128) | YES | - | (Documentar) |
| device_fingerprint | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_sessao)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_local -> local.id_local
- Estrangeira: id_perfil -> perfil.id_perfil
- Estrangeira: id_sistema -> sistema.id_sistema
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_sessao_usuario)
- KEY (uuid_sessao)
- KEY (id_usuario)
- KEY (id_perfil)
- KEY (id_sistema)
- KEY (id_unidade)
- KEY (token_jwt(255)
- KEY (refresh_token(255)
- KEY (expira_em)
- KEY (ativo)
- KEY (id_local)
- KEY (id_sala)
- KEY (id_usuario,id_entidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

