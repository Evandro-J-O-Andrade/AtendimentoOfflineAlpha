# ffa_procedimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_procedimento | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('RX' | NOT NULL | - | (Documentar) |
| status | enum('SOLICITADO' | NOT NULL | - | (Documentar) |
| prioridade | enum('NORMAL' | YES | - | (Documentar) |
| id_usuario_solicitante | bigint | YES | - | (Documentar) |
| id_usuario_execucao | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| iniciado_em | datetime | YES | - | (Documentar) |
| finalizado_em | datetime | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_procedimento)
- KEY (id_ffa)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

