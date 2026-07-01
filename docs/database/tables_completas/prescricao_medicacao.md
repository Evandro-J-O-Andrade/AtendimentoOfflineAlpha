# prescricao_medicacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_prescricao | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_medico | bigint | NOT NULL | - | (Documentar) |
| descricao | text | NOT NULL | - | (Documentar) |
| controlada | tinyint(1) | YES | - | (Documentar) |
| criada_em | datetime | YES | - | (Documentar) |
| ativa | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_medico -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_prescricao)
- KEY (id_medico)
- KEY (id_ffa)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

