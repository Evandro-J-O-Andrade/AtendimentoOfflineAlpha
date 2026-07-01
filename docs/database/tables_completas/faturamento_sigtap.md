# faturamento_sigtap

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | int | NOT NULL | - | (Documentar) |
| codigo_procedimento | varchar(10) | NOT NULL | - | (Documentar) |
| nome_procedimento | varchar(255) | YES | - | (Documentar) |
| valor_sh | decimal(10 | YES | - | (Documentar) |
| valor_sa | decimal(10 | YES | - | (Documentar) |
| complexidade | enum('BASICA' | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_procedimento)

## Indices

- PRIMARY KEY (id)
- KEY (codigo_procedimento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

