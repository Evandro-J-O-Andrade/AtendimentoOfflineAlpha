# faturamento_regras_validacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | int | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| possui_cid | tinyint(1) | YES | - | (Documentar) |
| possui_cbo | tinyint(1) | YES | - | (Documentar) |
| possui_prescricao | tinyint(1) | YES | - | (Documentar) |
| apto_para_faturar | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_atendimento)

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

