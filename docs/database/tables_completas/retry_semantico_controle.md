# retry_semantico_controle

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_retry | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(60) | NOT NULL | - | (Documentar) |
| versao_logica | bigint | YES | - | (Documentar) |
| tentativas | int | YES | - | (Documentar) |
| max_tentativas | int | YES | - | (Documentar) |
| bloqueado | tinyint(1) | YES | - | (Documentar) |
| ultimo_erro | varchar(255) | YES | - | (Documentar) |
| proxima_tentativa | datetime(6) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_retry)
- KEY (bloqueado,proxima_tentativa)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

