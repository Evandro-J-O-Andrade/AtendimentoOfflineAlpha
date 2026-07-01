# painel_mensagem_consumo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_consumo | bigint | NOT NULL | - | (Documentar) |
| id_mensagem | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | NOT NULL | - | (Documentar) |
| consumido_em | datetime | NOT NULL | - | (Documentar) |
| consumido_por | varchar(80) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_mensagem,id_painel)
- Estrangeira: id_mensagem -> painel_mensagem.id_mensagem
- Estrangeira: id_painel -> painel.id_painel

## Indices

- PRIMARY KEY (id_consumo)
- KEY (id_mensagem,id_painel)
- KEY (id_painel,consumido_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

