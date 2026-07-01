# atendimento_sumario_alta

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_medico_alta | bigint | NOT NULL | - | (Documentar) |
| motivo_internacao | text | YES | - | (Documentar) |
| resumo_clinico | text | YES | - | (Documentar) |
| procedimentos_realizados | text | YES | - | (Documentar) |
| orientacoes_pos_alta | text | YES | - | (Documentar) |
| medicamentos_receitados | text | YES | - | (Documentar) |
| data_alta | datetime | YES | - | (Documentar) |
| assinatura_hash | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_atendimento)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

