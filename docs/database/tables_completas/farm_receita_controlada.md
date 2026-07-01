# farm_receita_controlada

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_receita | bigint | NOT NULL | - | (Documentar) |
| id_operacao | bigint | NOT NULL | - | (Documentar) |
| origem | enum('INTERNO' | NOT NULL | - | (Documentar) |
| id_prescricao_medicacao | bigint | YES | - | (Documentar) |
| id_atendimento_ext | bigint | YES | - | (Documentar) |
| paciente_nome | varchar(255) | YES | - | (Documentar) |
| paciente_documento | varchar(40) | YES | - | (Documentar) |
| id_medico | bigint | YES | - | (Documentar) |
| id_prescritor_externo | bigint | YES | - | (Documentar) |
| numero_receita | varchar(80) | YES | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| recebido_em | datetime | YES | - | (Documentar) |
| id_usuario_recebimento | bigint | YES | - | (Documentar) |
| id_usuario_baixa_final | bigint | YES | - | (Documentar) |
| baixa_final_em | datetime | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento_ext -> farm_atendimento_externo.id_atendimento_ext
- Estrangeira: id_operacao -> farm_operacao.id_operacao

## Indices

- PRIMARY KEY (id_receita)
- KEY (status)
- KEY (id_operacao)
- KEY (id_atendimento_ext)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

