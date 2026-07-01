# auth_parametro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_parametro | bigint | NOT NULL | - | (Documentar) |
| chave | varchar(100) | NOT NULL | - | (Documentar) |
| valor | text | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| tipo_parametro | enum('SENHA' | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (chave)

## Indices

- PRIMARY KEY (id_parametro)
- KEY (chave)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

