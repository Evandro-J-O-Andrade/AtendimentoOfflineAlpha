# ffa_sinais_vitais

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sinais | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_fila | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| data_coleta | datetime | NOT NULL | - | (Documentar) |
| pressao_sistolica | int | YES | - | (Documentar) |
| pressao_diastolica | int | YES | - | (Documentar) |
| freq_cardiaca | int | YES | - | (Documentar) |
| freq_respiratoria | int | YES | - | (Documentar) |
| temperatura | decimal(4 | YES | - | (Documentar) |
| saturacao | int | YES | - | (Documentar) |
| glicemia | int | YES | - | (Documentar) |
| escala_dor | tinyint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_local_operacional -> local_operacional.id_local_operacional
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_sinais)
- KEY (id_ffa,data_coleta)
- KEY (id_sessao_usuario)
- KEY (id_usuario,data_coleta)
- KEY (id_local_operacional)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

