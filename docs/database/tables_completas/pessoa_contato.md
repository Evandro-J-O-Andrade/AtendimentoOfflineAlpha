# pessoa_contato

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('EMAIL' | YES | - | (Documentar) |
| valor | varchar(150) | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_pessoa -> pessoa.id_pessoa

## Indices

- PRIMARY KEY (id)
- KEY (id_pessoa)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

