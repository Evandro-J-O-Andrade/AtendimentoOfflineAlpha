# fluxo_status

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_fluxo_status | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | NOT NULL | - | (Documentar) |
| descricao | varchar(150) | NOT NULL | - | (Documentar) |
| tipo | enum('INICIAL' | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)

## Indices

- PRIMARY KEY (id_fluxo_status)
- KEY (codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

