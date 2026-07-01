# estoque_reserva_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_reserva | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | enum('CRIAR' | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| hash_anterior | char(64) | YES | - | (Documentar) |
| hash_atual | char(64) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_reserva -> estoque_reserva.id_reserva

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_reserva)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

