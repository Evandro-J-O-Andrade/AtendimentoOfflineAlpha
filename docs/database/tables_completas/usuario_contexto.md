# usuario_contexto

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_contexto | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_perfil -> perfil.id_perfil
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_usuario_contexto)
- KEY (id_usuario)
- KEY (id_perfil)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

