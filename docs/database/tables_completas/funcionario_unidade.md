# funcionario_unidade

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_funcionario_unidade | bigint | NOT NULL | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| funcao_unidade | varchar(150) | YES | - | (Documentar) |
| data_inicio | date | YES | - | (Documentar) |
| data_fim | date | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_funcionario -> funcionario.id_funcionario
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_funcionario_unidade)
- KEY (id_funcionario)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

