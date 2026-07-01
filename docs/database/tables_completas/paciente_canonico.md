# paciente_canonico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_paciente | bigint | NOT NULL | - | (Documentar) |
| uuid_paciente | char(36) | NOT NULL | - | (Documentar) |
| hash_identidade | char(64) | NOT NULL | - | (Documentar) |
| nome | varchar(200) | NOT NULL | - | (Documentar) |
| data_nascimento | date | YES | - | (Documentar) |
| sexo | char(1) | YES | - | (Documentar) |
| documento_principal | varchar(50) | YES | - | (Documentar) |
| metadata_identidade | json | YES | - | (Documentar) |
| estado_paciente | enum('ATIVO' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_paciente)
- Unica: UNIQUE KEY (hash_identidade)

## Indices

- PRIMARY KEY (id_paciente)
- KEY (uuid_paciente)
- KEY (hash_identidade)
- KEY (nome)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

