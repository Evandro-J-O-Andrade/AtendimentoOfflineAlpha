# internacao_movimentacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| id_leito_origem | bigint | YES | - | (Documentar) |
| id_leito_destino | bigint | NOT NULL | - | (Documentar) |
| id_usuario_transferencia | bigint | NOT NULL | - | (Documentar) |
| data_movimentacao | datetime | YES | - | (Documentar) |
| motivo | varchar(255) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_internacao -> internacao.id_internacao

## Indices

- PRIMARY KEY (id)
- KEY (id_internacao)
- KEY (id_internacao,data_movimentacao)
- KEY (id_sessao_usuario,data_movimentacao)
- KEY (id_unidade)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

