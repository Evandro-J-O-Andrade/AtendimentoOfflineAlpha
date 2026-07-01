# agendamentos_eventos

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_agendamento | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('CRIADO' | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| de_status | varchar(30) | YES | - | (Documentar) |
| para_status | varchar(30) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_agendamento -> agendamentos.id_agendamento
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_agendamento,criado_em)
- KEY (id_usuario)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

