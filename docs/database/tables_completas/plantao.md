# plantao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_plantao | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| tipo_plantao | enum('CLINICO' | NOT NULL | - | (Documentar) |
| inicio_plantao | datetime | NOT NULL | - | (Documentar) |
| fim_plantao | datetime | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_funcionario -> funcionario.id_funcionario
- Estrangeira: id_local -> local.id_local
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_plantao)
- KEY (id_unidade,ativo,inicio_plantao,fim_plantao)
- KEY (id_funcionario)
- KEY (id_local)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

