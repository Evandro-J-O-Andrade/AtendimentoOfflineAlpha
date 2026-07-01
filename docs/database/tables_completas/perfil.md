# perfil

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | NOT NULL | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| contexto | varchar(40) | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_perfil)
- KEY (codigo)
- KEY (ativo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

