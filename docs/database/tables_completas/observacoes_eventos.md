# observacoes_eventos

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| entidade | varchar(50) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| contexto | varchar(50) | YES | - | (Documentar) |
| tipo | varchar(50) | YES | - | (Documentar) |
| texto | text | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id)
- KEY (id_usuario)
- KEY (entidade,id_entidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

