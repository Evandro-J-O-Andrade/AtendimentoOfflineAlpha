# estoque_evento_confirmacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| hash_execucao | char(64) | NOT NULL | - | (Documentar) |
| id_movimento | bigint | NOT NULL | - | (Documentar) |
| id_usuario_executor | bigint | NOT NULL | - | (Documentar) |
| id_usuario_confirmador | bigint | YES | - | (Documentar) |
| tipo_evento | varchar(50) | NOT NULL | - | (Documentar) |
| status_confirmacao | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| criado_em | timestamp | YES | - | (Documentar) |
| atualizado_em | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_execucao)

## Indices

- PRIMARY KEY (id_evento)
- KEY (hash_execucao)
- KEY (id_movimento)
- KEY (status_confirmacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

