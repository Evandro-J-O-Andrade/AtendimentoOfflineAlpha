# escala_plantao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_escala | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| data | date | NOT NULL | - | (Documentar) |
| id_plantao_modelo | bigint | NOT NULL | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_plantao_modelo -> plantao_modelo.id_plantao_modelo
- Estrangeira: id_sistema -> sistema.id_sistema
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_escala)
- KEY (id_unidade,data)
- KEY (id_sistema)
- KEY (id_plantao_modelo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

