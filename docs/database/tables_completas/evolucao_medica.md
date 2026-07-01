# evolucao_medica

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evolucao | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| descricao | text | NOT NULL | - | (Documentar) |
| id_medico | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_medico -> medico.id_usuario

## Indices

- PRIMARY KEY (id_evolucao)
- KEY (id_internacao)
- KEY (id_medico)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

