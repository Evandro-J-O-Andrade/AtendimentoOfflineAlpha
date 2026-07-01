# usuario_sistema

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_sistema | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_usuario,id_sistema)
- Estrangeira: id_perfil -> perfil.id_perfil
- Estrangeira: id_sistema -> sistema.id_sistema
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_usuario_sistema)
- KEY (id_usuario,id_sistema)
- KEY (id_usuario)
- KEY (id_sistema)
- KEY (id_perfil)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

