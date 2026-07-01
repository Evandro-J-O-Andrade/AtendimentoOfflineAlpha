# usuario_local

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_local | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_usuario,id_local)
- Estrangeira: id_local -> local.id_local
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_usuario_local)
- KEY (id_usuario,id_local)
- KEY (id_usuario)
- KEY (id_local)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

