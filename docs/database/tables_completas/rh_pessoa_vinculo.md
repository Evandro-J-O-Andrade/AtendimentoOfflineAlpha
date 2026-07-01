# rh_pessoa_vinculo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_rh_vinculo | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| tipo_vinculo | enum('FUNCIONARIO' | NOT NULL | - | (Documentar) |
| matricula | varchar(40) | YES | - | (Documentar) |
| cpf | varchar(14) | YES | - | (Documentar) |
| rg | varchar(30) | YES | - | (Documentar) |
| orgao_emissor | varchar(20) | YES | - | (Documentar) |
| pis_pasep | varchar(20) | YES | - | (Documentar) |
| data_admissao | date | YES | - | (Documentar) |
| data_demissao | date | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| id_unidade_lotacao | bigint | YES | - | (Documentar) |
| id_local_lotacao | bigint | YES | - | (Documentar) |
| cargo | varchar(120) | YES | - | (Documentar) |
| setor | varchar(120) | YES | - | (Documentar) |
| email | varchar(120) | YES | - | (Documentar) |
| telefone | varchar(40) | YES | - | (Documentar) |
| endereco | varchar(255) | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (matricula)

## Indices

- PRIMARY KEY (id_rh_vinculo)
- KEY (matricula)
- KEY (id_pessoa)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

