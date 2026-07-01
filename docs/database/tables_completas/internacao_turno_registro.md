# internacao_turno_registro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_turno_registro | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| data_referencia | date | NOT NULL | - | (Documentar) |
| turno | enum('MANHA' | NOT NULL | - | (Documentar) |
| observacoes_gerais | text | YES | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
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
- Estrangeira: id_usuario_responsavel -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_internacao_turno_registro)
- KEY (id_internacao)
- KEY (data_referencia,turno)
- KEY (criado_em)
- KEY (id_usuario_responsavel)
- KEY (id_sessao_usuario)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

