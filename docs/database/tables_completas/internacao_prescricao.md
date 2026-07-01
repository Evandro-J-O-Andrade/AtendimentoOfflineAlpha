# internacao_prescricao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_prescricao | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| data_prescricao | datetime | NOT NULL | - | (Documentar) |
| status | enum('ATIVA' | NOT NULL | - | (Documentar) |
| observacoes | text | YES | - | (Documentar) |
| id_usuario_prescritor | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_usuario_prescritor -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_internacao_prescricao)
- KEY (id_internacao)
- KEY (data_prescricao)
- KEY (status)
- KEY (id_usuario_prescritor)
- KEY (id_sessao_usuario)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

