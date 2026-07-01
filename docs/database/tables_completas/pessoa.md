# pessoa

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(200) | NOT NULL | - | (Documentar) |
| nome_social | varchar(200) | YES | - | (Documentar) |
| sexo | enum('MASCULINO' | YES | - | (Documentar) |
| identidade_genero | enum('CIS_MASCULINO' | YES | - | (Documentar) |
| data_nascimento | date | YES | - | (Documentar) |
| nacionalidade | varchar(100) | YES | - | (Documentar) |
| naturalidade | varchar(150) | YES | - | (Documentar) |
| nome_mae | varchar(200) | YES | - | (Documentar) |
| nome_pai | varchar(200) | YES | - | (Documentar) |
| estado_civil | enum('SOLTEIRO' | YES | - | (Documentar) |
| tipo_pessoa | enum('PACIENTE' | YES | - | (Documentar) |
| foto_url | varchar(500) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_pessoa)
- KEY (nome)
- KEY (nome_social)
- KEY (data_nascimento)
- KEY (tipo_pessoa,ativo)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

