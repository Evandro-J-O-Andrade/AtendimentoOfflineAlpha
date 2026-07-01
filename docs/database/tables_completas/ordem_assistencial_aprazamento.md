# ordem_assistencial_aprazamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_aprazamento | bigint | NOT NULL | - | (Documentar) |
| id_item | bigint | NOT NULL | - | (Documentar) |
| previsto_em | datetime | NOT NULL | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| executado_em | datetime | YES | - | (Documentar) |
| id_usuario_execucao | bigint | YES | - | (Documentar) |
| id_sessao_usuario_execucao | bigint | YES | - | (Documentar) |
| id_local_operacional_execucao | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| criado_por | bigint | YES | - | (Documentar) |
| id_sessao_usuario_criado | bigint | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_item,previsto_em)
- Estrangeira: id_local_operacional_execucao -> local_operacional.id_local_operacional
- Estrangeira: id_usuario_execucao -> usuario.id_usuario
- Estrangeira: id_item -> ordem_assistencial_item.id_item
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_aprazamento)
- KEY (id_item,previsto_em)
- KEY (status,previsto_em)
- KEY (id_usuario_execucao)
- KEY (id_sessao_usuario_execucao)
- KEY (id_local_operacional_execucao)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

