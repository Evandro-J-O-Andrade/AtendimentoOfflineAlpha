# fila_operacional

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_fila | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('TRIAGEM' | NOT NULL | - | (Documentar) |
| substatus | enum('AGUARDANDO' | NOT NULL | - | (Documentar) |
| prioridade | enum('VERMELHO' | YES | - | (Documentar) |
| data_entrada | datetime | NOT NULL | - | (Documentar) |
| entrada_original_em | datetime | YES | - | (Documentar) |
| nao_compareceu_em | datetime | YES | - | (Documentar) |
| retorno_permitido_ate | datetime | YES | - | (Documentar) |
| retorno_utilizado | tinyint(1) | NOT NULL | - | (Documentar) |
| retorno_em | datetime | YES | - | (Documentar) |
| data_inicio | datetime | YES | - | (Documentar) |
| reavaliar_em | datetime | YES | - | (Documentar) |
| data_fim | datetime | YES | - | (Documentar) |
| id_responsavel | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_responsavel -> usuario.id_usuario
- Estrangeira: id_local -> local_atendimento.id_local

## Indices

- PRIMARY KEY (id_fila)
- KEY (id_responsavel)
- KEY (id_local)
- KEY (id_ffa,tipo,substatus)
- KEY (tipo,prioridade,substatus)
- KEY (tipo,substatus,prioridade,data_entrada,id_local_operacional)
- KEY (tipo,substatus,reavaliar_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

