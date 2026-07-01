# auth_grupo_usuario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_grupo_usuario | bigint | NOT NULL | - | (Documentar) |
| id_grupo | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| papel | enum('MEMBRO' | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_grupo,id_usuario)
- Estrangeira: id_grupo -> auth_grupo.id_grupo
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_grupo_usuario)
- KEY (id_grupo,id_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

