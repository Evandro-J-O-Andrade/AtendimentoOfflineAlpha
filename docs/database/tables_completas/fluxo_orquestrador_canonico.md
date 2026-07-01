# fluxo_orquestrador_canonico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_orquestrador | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| estado_atual | varchar(50) | NOT NULL | - | (Documentar) |
| estado_proximo | varchar(50) | NOT NULL | - | (Documentar) |
| regra_execucao | json | NOT NULL | - | (Documentar) |
| criticidade_fluxo | tinyint | NOT NULL | - | (Documentar) |
| exige_assinatura_digital | tinyint(1) | YES | - | (Documentar) |
| timeout_execucao_segundos | int | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (dominio_fluxo,estado_atual,estado_proximo)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_orquestrador)
- KEY (dominio_fluxo,estado_atual,estado_proximo)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

