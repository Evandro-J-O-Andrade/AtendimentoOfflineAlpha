# auditoria_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_auditoria | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| dominio | varchar(50) | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(100) | NOT NULL | - | (Documentar) |
| id_referencia | bigint | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| metadata | json | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| status | varchar(20) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_auditoria)
- KEY (id_usuario)
- KEY (id_sessao_usuario)
- KEY (dominio,tipo_evento)
- KEY (id_referencia)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

