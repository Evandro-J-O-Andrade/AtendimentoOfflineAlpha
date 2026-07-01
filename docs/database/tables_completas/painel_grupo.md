# painel_grupo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_grupo | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(50) | NOT NULL | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_grupo)
- KEY (codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

