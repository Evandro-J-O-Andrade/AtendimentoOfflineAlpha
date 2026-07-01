# runtime_execution_queue

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | varchar(36) | NOT NULL | - | (Documentar) |
| id_sessao | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| acao | varchar(100) | NOT NULL | - | (Documentar) |
| contexto | varchar(60) | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| status | enum('PENDENTE' | YES | - | (Documentar) |
| prioridade | int | YES | - | (Documentar) |
| retry_count | int | YES | - | (Documentar) |
| ultimo_erro | text | YES | - | (Documentar) |
| duracao_ms | int | YES | - | (Documentar) |
| resultado | text | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (status,criado_em)
- KEY (id_usuario)
- KEY (id_sessao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

