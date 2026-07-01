# anamnese

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_anamnese | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | YES | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_atendimento -> atendimento.id_atendimento

## Indices

- PRIMARY KEY (id_anamnese)
- KEY (id_atendimento)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

