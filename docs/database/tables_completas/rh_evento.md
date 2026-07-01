# rh_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_rh_vinculo | bigint | YES | - | (Documentar) |
| id_registro | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| evento | varchar(50) | NOT NULL | - | (Documentar) |
| detalhe | varchar(255) | YES | - | (Documentar) |
| payload_json | json | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_rh_vinculo)
- KEY (id_registro)
- KEY (evento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

