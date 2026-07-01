# escala_medica

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_usuario_medico | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| data_plantao | date | NOT NULL | - | (Documentar) |
| turno | enum('MANHA' | NOT NULL | - | (Documentar) |
| status_presenca | enum('PREVISTO' | YES | - | (Documentar) |
| id_substituto | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id)
- KEY (data_plantao,id_unidade)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

