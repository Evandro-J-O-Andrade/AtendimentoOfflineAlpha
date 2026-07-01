# notificacao_epidemiologica

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| cid_10 | varchar(10) | NOT NULL | - | (Documentar) |
| doenca_suspeita | varchar(100) | YES | - | (Documentar) |
| status_notificacao | enum('PENDENTE' | YES | - | (Documentar) |
| data_evento | datetime | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario_criador | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| protocolo_ms | varchar(50) | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (id_sessao_usuario)
- KEY (id_usuario_criador)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

