# internacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_leito | int | YES | - | (Documentar) |
| tipo | enum('OBSERVACAO' | NOT NULL | - | (Documentar) |
| motivo | text | YES | - | (Documentar) |
| status | enum('ATIVA' | YES | - | (Documentar) |
| data_entrada | datetime | NOT NULL | - | (Documentar) |
| id_usuario_entrada | bigint | YES | - | (Documentar) |
| data_saida | datetime | YES | - | (Documentar) |
| id_usuario_saida | bigint | YES | - | (Documentar) |
| motivo_alta | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| encerrado_em | datetime | YES | - | (Documentar) |
| precaucao | enum('PADRAO' | YES | - | (Documentar) |
| previsao_alta | datetime | YES | - | (Documentar) |
| id_medico_responsavel | bigint | YES | - | (Documentar) |
| id_sessao_usuario_entrada | bigint | YES | - | (Documentar) |
| id_sessao_usuario_saida | bigint | YES | - | (Documentar) |
| id_local_operacional_entrada | bigint | YES | - | (Documentar) |
| id_local_operacional_saida | bigint | YES | - | (Documentar) |
| id_unidade_entrada | bigint | YES | - | (Documentar) |
| id_unidade_saida | bigint | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_leito -> leito.id_leito

## Indices

- PRIMARY KEY (id_internacao)
- KEY (id_ffa)
- KEY (status)
- KEY (id_leito)
- KEY (id_ffa,status)
- KEY (id_leito,status)
- KEY (data_entrada,data_saida)
- KEY (status,data_entrada,data_saida)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

