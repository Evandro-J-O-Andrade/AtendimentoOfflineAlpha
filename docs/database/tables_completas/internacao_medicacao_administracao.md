# internacao_medicacao_administracao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_medicacao_administracao | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| id_internacao_prescricao_item | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | NOT NULL | - | (Documentar) |
| status | enum('ADMINISTRADO' | NOT NULL | - | (Documentar) |
| dose_aplicada | varchar(60) | YES | - | (Documentar) |
| via_administracao | varchar(60) | YES | - | (Documentar) |
| observacoes | text | YES | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_internacao_prescricao_item -> internacao_prescricao_item.id_internacao_prescricao_item
- Estrangeira: id_usuario_responsavel -> usuario.id_usuario
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_internacao_medicacao_administracao)
- KEY (id_internacao)
- KEY (id_internacao_prescricao_item)
- KEY (data_hora)
- KEY (id_usuario_responsavel)
- KEY (id_sessao_usuario)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

