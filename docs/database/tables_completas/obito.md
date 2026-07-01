# obito

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_obito | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| data_hora_obito | datetime | NOT NULL | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
| evolucao_inicial | text | NOT NULL | - | (Documentar) |
| evolucao_final | text | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| status | enum('REGISTRADO' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| cancelado_em | datetime | YES | - | (Documentar) |
| cancelado_por | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_ffa)

## Indices

- PRIMARY KEY (id_obito)
- KEY (id_ffa)
- KEY (data_hora_obito)
- KEY (status)
- KEY (id_sessao_usuario)
- KEY (id_ffa,status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

