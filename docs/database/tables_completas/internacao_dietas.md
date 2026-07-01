# internacao_dietas

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_prescricao_item | bigint | NOT NULL | - | (Documentar) |
| consistencia | enum('LIVRE' | YES | - | (Documentar) |
| restricao | varchar(255) | YES | - | (Documentar) |
| volume_total_dia | int | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_prescricao_item -> prescricao_itens.id

## Indices

- PRIMARY KEY (id)
- KEY (id_prescricao_item)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

