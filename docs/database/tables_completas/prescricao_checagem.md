# prescricao_checagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_checagem | bigint | NOT NULL | - | (Documentar) |
| id_prescricao_item | bigint | NOT NULL | - | (Documentar) |
| id_usuario_enfermeiro | bigint | NOT NULL | - | (Documentar) |
| data_hora_checagem | datetime | YES | - | (Documentar) |
| status | enum('ADMINISTRADO' | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_prescricao_item -> prescricao_item.id_item
- Estrangeira: id_usuario_enfermeiro -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_checagem)
- KEY (id_prescricao_item)
- KEY (id_usuario_enfermeiro)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

