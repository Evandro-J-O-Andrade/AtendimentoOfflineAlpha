# auth_notificacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_notificacao | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo_notificacao | enum('LOGIN_NOVO_DISPOSITIVO' | NOT NULL | - | (Documentar) |
| titulo | varchar(200) | NOT NULL | - | (Documentar) |
| mensagem | text | NOT NULL | - | (Documentar) |
| lido | tinyint(1) | YES | - | (Documentar) |
| lido_em | datetime | YES | - | (Documentar) |
| dados_extras | json | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_notificacao)
- KEY (id_usuario)
- KEY (lido)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

