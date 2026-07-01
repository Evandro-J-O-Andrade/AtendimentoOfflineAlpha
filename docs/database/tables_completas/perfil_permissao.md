# perfil_permissao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| id_permissao | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_perfil -> perfil.id_perfil
- Estrangeira: id_permissao -> permissao.id_permissao

## Indices

- KEY (id_perfil)
- KEY (id_permissao)
- KEY (id_perfil)
- KEY (id_permissao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

