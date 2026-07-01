# funcionario_especialidade

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_funcionario_especialidade | bigint | NOT NULL | - | (Documentar) |
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| especialidade | varchar(150) | NOT NULL | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_funcionario -> funcionario.id_funcionario

## Indices

- PRIMARY KEY (id_funcionario_especialidade)
- KEY (id_funcionario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

