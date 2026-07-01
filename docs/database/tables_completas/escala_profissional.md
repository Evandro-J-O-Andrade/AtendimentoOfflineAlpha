# escala_profissional

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_escala_profissional | bigint | NOT NULL | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| data_inicio | datetime | NOT NULL | - | (Documentar) |
| data_fim | datetime | NOT NULL | - | (Documentar) |
| tipo_escala | enum('PLANTAO' | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_funcionario -> funcionario.id_funcionario
- Estrangeira: id_local -> local.id_local
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_escala_profissional)
- KEY (id_funcionario)
- KEY (id_unidade)
- KEY (id_local)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

