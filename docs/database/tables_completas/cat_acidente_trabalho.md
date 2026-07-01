# cat_acidente_trabalho

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_pessoa_trabalhador | bigint | NOT NULL | - | (Documentar) |
| data_acidente | datetime | NOT NULL | - | (Documentar) |
| tipo_acidente | enum('TIPICO' | NOT NULL | - | (Documentar) |
| descricao_acidente | text | YES | - | (Documentar) |
| agente_causador | varchar(120) | YES | - | (Documentar) |
| parte_corpo | varchar(120) | YES | - | (Documentar) |
| cid10_relacionado | varchar(10) | YES | - | (Documentar) |
| status_cat | enum('ABERTA' | NOT NULL | - | (Documentar) |
| numero_cat | varchar(40) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario_criador | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa_trabalhador -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)
- KEY (id_pessoa_trabalhador)
- KEY (status_cat)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

