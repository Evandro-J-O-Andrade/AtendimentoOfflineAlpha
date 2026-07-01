# usuario_perfil

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_perfil -> perfil.id_perfil
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- KEY (id_perfil)
- KEY (id_usuario)
- KEY (id_perfil)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

