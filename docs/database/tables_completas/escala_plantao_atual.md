# escala_plantao_atual

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_setor | int | YES | - | (Documentar) |
| registro_profissional | varchar(50) | YES | - | (Documentar) |
| data_inicio | datetime | YES | - | (Documentar) |
| data_fim | datetime | YES | - | (Documentar) |
| status_plantao | enum('ATIVO' | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id)
- KEY (id_usuario,status_plantao)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

