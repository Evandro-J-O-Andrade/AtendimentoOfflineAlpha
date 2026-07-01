# atendimento_pedidos_exame

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_medico_solicitante | bigint | NOT NULL | - | (Documentar) |
| id_exame_tuss | varchar(20) | NOT NULL | - | (Documentar) |
| status_exame | enum('SOLICITADO' | YES | - | (Documentar) |
| prioridade | enum('ELETIVO' | YES | - | (Documentar) |
| data_solicitacao | datetime | YES | - | (Documentar) |
| url_laudo_pacs | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_exame_tuss -> tabela_tuss.codigo_tuss

## Indices

- PRIMARY KEY (id)
- KEY (id_exame_tuss)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

