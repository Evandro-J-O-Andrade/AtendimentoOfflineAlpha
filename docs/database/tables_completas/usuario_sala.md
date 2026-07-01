# usuario_sala

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_sala | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sala | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_usuario,id_sala)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_sala -> sala.id_sala
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_usuario_sala)
- KEY (id_usuario,id_sala)
- KEY (id_usuario)
- KEY (id_sala)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

