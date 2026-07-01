# usuario_setor

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario_setor | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_setor | int | NOT NULL | - | (Documentar) |
| pode_operar | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_usuario,id_setor)

## Indices

- PRIMARY KEY (id_usuario_setor)
- KEY (id_usuario,id_setor)
- KEY (id_usuario)
- KEY (id_setor)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

