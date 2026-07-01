# auth_sessao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sessao | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_perfil | bigint | YES | - | (Documentar) |
| token_sessao | varchar(255) | NOT NULL | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | text | YES | - | (Documentar) |
| dispositivo | varchar(100) | YES | - | (Documentar) |
| geo_localizacao | varchar(200) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| expira_em | datetime | NOT NULL | - | (Documentar) |
| ultima_atividade | datetime | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_sessao)
- KEY (id_usuario)
- KEY (token_sessao)
- KEY (expira_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

