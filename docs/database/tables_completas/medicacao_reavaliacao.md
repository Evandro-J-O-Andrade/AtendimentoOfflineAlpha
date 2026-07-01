# medicacao_reavaliacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_reavaliacao | bigint | NOT NULL | - | (Documentar) |
| id_fila_medicacao | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| previsto_em | datetime | NOT NULL | - | (Documentar) |
| executado_em | datetime | YES | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_usuario_criador | bigint | NOT NULL | - | (Documentar) |
| id_usuario_executor | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_fila_medicacao -> fila_operacional.id_fila
- Estrangeira: id_local_operacional -> local_operacional.id_local_operacional
- Estrangeira: id_usuario_criador -> usuario.id_usuario
- Estrangeira: id_usuario_executor -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_reavaliacao)
- KEY (id_fila_medicacao,status,previsto_em)
- KEY (id_ffa,status,previsto_em)
- KEY (id_sessao_usuario)
- KEY (id_local_operacional)
- KEY (id_usuario_criador)
- KEY (id_usuario_executor)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

