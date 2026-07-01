# senha_status

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_senha_status | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(30) | NOT NULL | - | (Documentar) |
| descricao | varchar(150) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| ordem_fluxo | int | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_senha_status)
- KEY (codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

