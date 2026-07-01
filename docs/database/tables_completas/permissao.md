# permissao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_permissao | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(80) | NOT NULL | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| dominio | varchar(40) | YES | - | (Documentar) |
| nome_procedure | varchar(120) | YES | - | (Documentar) |
| acao_frontend | varchar(80) | YES | - | (Documentar) |
| metadata | json | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| grupo_menu | varchar(60) | YES | - | (Documentar) |
| icone | varchar(60) | YES | - | (Documentar) |
| ordem_menu | int | YES | - | (Documentar) |
| visivel_menu | tinyint | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_permissao)
- KEY (codigo)
- KEY (dominio)
- KEY (ativo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

