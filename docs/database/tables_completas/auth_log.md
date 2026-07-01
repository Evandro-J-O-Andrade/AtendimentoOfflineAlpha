# auth_log

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_log | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| tipo_evento | enum('LOGIN_SUCESSO' | NOT NULL | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | text | YES | - | (Documentar) |
| dispositivo | varchar(100) | YES | - | (Documentar) |
| localizacao | varchar(200) | YES | - | (Documentar) |
| mensagem | text | YES | - | (Documentar) |
| dados_extras | json | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_log)
- KEY (id_usuario)
- KEY (tipo_evento)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

