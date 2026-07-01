# faturamento_codigo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_codigo | bigint | NOT NULL | - | (Documentar) |
| sistema | enum('SIGTAP' | NOT NULL | - | (Documentar) |
| codigo | varchar(30) | NOT NULL | - | (Documentar) |
| tipo | enum('PROCEDIMENTO' | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| unidade_medida | varchar(30) | YES | - | (Documentar) |
| ativo | tinyint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (sistema,codigo)

## Indices

- PRIMARY KEY (id_codigo)
- KEY (sistema,codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

