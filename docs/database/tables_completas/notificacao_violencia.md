# notificacao_violencia

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| categoria | enum('VIOLENCIA' | NOT NULL | - | (Documentar) |
| tipo | varchar(80) | YES | - | (Documentar) |
| data_ocorrencia | datetime | YES | - | (Documentar) |
| local_ocorrencia | varchar(120) | YES | - | (Documentar) |
| suspeito_relacao | varchar(120) | YES | - | (Documentar) |
| cid10_relacionado | varchar(10) | YES | - | (Documentar) |
| status_notificacao | enum('ABERTA' | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario_criador | bigint | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| protocolo_externo | varchar(60) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)
- KEY (status_notificacao)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

