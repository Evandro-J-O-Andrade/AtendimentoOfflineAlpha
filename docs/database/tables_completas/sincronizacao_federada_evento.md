# sincronizacao_federada_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sync | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(60) | NOT NULL | - | (Documentar) |
| estado_origem | varchar(60) | YES | - | (Documentar) |
| estado_destino | varchar(60) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| sincronizado | tinyint(1) | YES | - | (Documentar) |
| versao_logica | bigint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_sync)
- KEY (sincronizado,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

