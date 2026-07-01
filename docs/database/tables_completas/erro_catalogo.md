# erro_catalogo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_erro_catalogo | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(20) | NOT NULL | - | (Documentar) |
| dominio | varchar(50) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_erro_catalogo)
- KEY (codigo)
- KEY (dominio)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

