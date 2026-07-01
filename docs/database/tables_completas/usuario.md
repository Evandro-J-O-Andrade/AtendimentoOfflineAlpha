# usuario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| login | varchar(80) | NOT NULL | - | (Documentar) |
| senha_hash | varchar(255) | NOT NULL | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| tentativas_login | int | YES | - | (Documentar) |
| bloqueado_ate | datetime(6) | YES | - | (Documentar) |
| ultimo_login | datetime(6) | YES | - | (Documentar) |
| ultimo_ip | varchar(45) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (login)
- Unica: UNIQUE KEY (id_usuario,id_entidade)
- Unica: UNIQUE KEY (id_usuario,id_entidade)
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_usuario)
- KEY (login)
- KEY (id_usuario,id_entidade)
- KEY (id_usuario,id_entidade)
- KEY (login)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

