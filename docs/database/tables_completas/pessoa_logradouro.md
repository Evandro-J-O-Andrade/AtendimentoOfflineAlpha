# pessoa_logradouro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| id_logradouro | bigint | NOT NULL | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| data_inicio | date | NOT NULL | - | (Documentar) |
| data_fim | date | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa -> pessoa.id_pessoa
- Estrangeira: id_logradouro -> logradouro.id_logradouro

## Indices

- KEY (id_logradouro)
- KEY (id_pessoa,ativo)
- KEY (id_pessoa,principal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

