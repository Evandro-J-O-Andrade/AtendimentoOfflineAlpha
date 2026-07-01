# funcionario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_funcionario | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| matricula | varchar(50) | YES | - | (Documentar) |
| tipo_funcionario | enum('MEDICO' | YES | - | (Documentar) |
| cargo | varchar(150) | YES | - | (Documentar) |
| departamento | varchar(150) | YES | - | (Documentar) |
| data_admissao | date | YES | - | (Documentar) |
| data_demissao | date | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_funcionario)
- KEY (id_pessoa)
- KEY (id_entidade)
- KEY (matricula)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

