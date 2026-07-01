# enfermagem_aprazamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| medicamento | varchar(255) | NOT NULL | - | (Documentar) |
| via_administracao | varchar(50) | YES | - | (Documentar) |
| frequencia | varchar(50) | YES | - | (Documentar) |
| horario_previsto | datetime | NOT NULL | - | (Documentar) |
| horario_executado | datetime | YES | - | (Documentar) |
| id_usuario_execucao | bigint | YES | - | (Documentar) |
| status | enum('AGUARDANDO' | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)
- KEY (horario_previsto)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

