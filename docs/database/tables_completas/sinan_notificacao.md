# sinan_notificacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sinan | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
| tipo_notificacao | varchar(80) | NOT NULL | - | (Documentar) |
| status | enum('ABERTA' | NOT NULL | - | (Documentar) |
| payload_json | json | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_sinan)
- KEY (id_ffa)
- KEY (id_gpat)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

