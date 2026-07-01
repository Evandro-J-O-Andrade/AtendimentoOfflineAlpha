# plantao_escala

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_plantao_escala | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| data | date | NOT NULL | - | (Documentar) |
| turno | varchar(30) | NOT NULL | - | (Documentar) |
| hora_inicio | time | YES | - | (Documentar) |
| hora_fim | time | YES | - | (Documentar) |
| id_plantao_modelo | bigint | YES | - | (Documentar) |
| tipo_plantao | enum('CLINICO' | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_unidade,id_funcionario,data,turno)
- Estrangeira: id_funcionario -> funcionario.id_funcionario
- Estrangeira: id_plantao_modelo -> plantao_modelo.id_plantao_modelo
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_plantao_escala)
- KEY (id_unidade,id_funcionario,data,turno)
- KEY (id_unidade,data)
- KEY (id_funcionario)
- KEY (id_plantao_modelo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

