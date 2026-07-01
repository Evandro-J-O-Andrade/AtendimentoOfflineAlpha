# auth_tentativa_login

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tentativa | bigint | NOT NULL | - | (Documentar) |
| login | varchar(80) | NOT NULL | - | (Documentar) |
| ip_origem | varchar(45) | NOT NULL | - | (Documentar) |
| user_agent | text | YES | - | (Documentar) |
| sucesso | tinyint(1) | NOT NULL | - | (Documentar) |
| motivo_falha | varchar(100) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_tentativa)
- KEY (login)
- KEY (ip_origem)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

