# administracao_medicacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_admin | bigint | NOT NULL | - | (Documentar) |
| id_prescricao | bigint | NOT NULL | - | (Documentar) |
| id_enfermeiro | bigint | NOT NULL | - | (Documentar) |
| dose | varchar(50) | YES | - | (Documentar) |
| via | varchar(50) | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_prescricao -> prescricao_internacao.id_prescricao
- Estrangeira: id_enfermeiro -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_admin)
- KEY (id_prescricao)
- KEY (id_enfermeiro)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

