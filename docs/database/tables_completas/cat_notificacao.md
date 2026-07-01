# cat_notificacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cat | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| id_pedido_item | bigint | YES | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
| status | enum('ABERTA' | NOT NULL | - | (Documentar) |
| data_evento | datetime | YES | - | (Documentar) |
| local_evento | varchar(255) | YES | - | (Documentar) |
| ocupacao | varchar(120) | YES | - | (Documentar) |
| empresa | varchar(255) | YES | - | (Documentar) |
| cnpj | varchar(20) | YES | - | (Documentar) |
| detalhes | text | YES | - | (Documentar) |
| protocolo_interno | varchar(50) | YES | - | (Documentar) |
| protocolo_externo | varchar(80) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_cat)
- KEY (id_ffa)
- KEY (id_gpat)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

