# login_tentativa

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tentativa | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| login | varchar(80) | NOT NULL | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| dispositivo_origem | varchar(100) | YES | - | (Documentar) |
| tentativa_faixa_horaria | varchar(50) | YES | - | (Documentar) |
| sucesso | tinyint(1) | NOT NULL | - | (Documentar) |
| metadata | json | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_tentativa)
- KEY (login)
- KEY (ip_origem)
- KEY (id_usuario)
- KEY (dispositivo_origem)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

