# agenda_disponibilidade

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_disponibilidade | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | YES | - | (Documentar) |
| id_profissional | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| tipo | enum('ATENDIMENTO' | NOT NULL | - | (Documentar) |
| inicio_em | datetime | NOT NULL | - | (Documentar) |
| fim_em | datetime | NOT NULL | - | (Documentar) |
| recorrente | tinyint(1) | NOT NULL | - | (Documentar) |
| dia_semana | tinyint | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_usuario_criador | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_local_operacional -> local_operacional.id_local_operacional
- Estrangeira: id_profissional -> usuario.id_usuario
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario
- Estrangeira: id_sistema -> sistema.id_sistema
- Estrangeira: id_usuario_criador -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_disponibilidade)
- KEY (id_profissional,inicio_em,fim_em)
- KEY (id_sistema,id_unidade,inicio_em)
- KEY (id_local_operacional,inicio_em)
- KEY (id_unidade)
- KEY (id_usuario_criador)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

