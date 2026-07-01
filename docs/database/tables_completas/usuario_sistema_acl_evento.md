# usuario_sistema_acl_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_acl_evento | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(50) | NOT NULL | - | (Documentar) |
| sucesso | tinyint | YES | - | (Documentar) |
| origem_dispositivo | varchar(100) | YES | - | (Documentar) |
| origem_ip | varchar(50) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_acl_evento)
- KEY (id_usuario)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

