# farmaco_auditoria

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_auditoria | bigint | NOT NULL | - | (Documentar) |
| tabela | varchar(50) | YES | - | (Documentar) |
| id_registro | bigint | YES | - | (Documentar) |
| acao | enum('INSERT' | YES | - | (Documentar) |
| dados_antes | json | YES | - | (Documentar) |
| dados_depois | json | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| data_evento | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_auditoria)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

