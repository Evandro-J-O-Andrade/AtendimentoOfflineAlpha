# pessoa_email

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa_email | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| email | varchar(200) | NOT NULL | - | (Documentar) |
| tipo | enum('PESSOAL' | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| verificado | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| valido_de | date | YES | - | (Documentar) |
| valido_ate | date | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (email)
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id_pessoa_email)
- KEY (email)
- KEY (id_pessoa)
- KEY (principal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

