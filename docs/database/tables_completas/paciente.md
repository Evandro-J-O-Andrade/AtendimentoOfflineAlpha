# paciente

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| uuid_paciente | char(36) | NOT NULL | - | (Documentar) |
| hash_identidade | char(64) | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| prontuario | varchar(50) | YES | - | (Documentar) |
| data_cadastro | datetime | YES | - | (Documentar) |
| sexo | char(1) | YES | - | (Documentar) |
| data_nascimento | date | YES | - | (Documentar) |
| nome | varchar(200) | YES | - | (Documentar) |
| documento_principal | varchar(50) | YES | - | (Documentar) |
| metadata_identidade | json | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_paciente)
- Unica: UNIQUE KEY (hash_identidade)
- Unica: UNIQUE KEY (prontuario)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id)
- KEY (uuid_paciente)
- KEY (hash_identidade)
- KEY (prontuario)
- KEY (id_pessoa)
- KEY (nome)
- KEY (id_entidade)
- KEY (id_entidade,prontuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

