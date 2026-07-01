# pessoa_alergias

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_pessoa | bigint | NOT NULL | - | (Documentar) |
| substancia | varchar(255) | NOT NULL | - | (Documentar) |
| gravidade | enum('LEVE' | YES | - | (Documentar) |
| registrado_por | bigint | YES | - | (Documentar) |
| data_registro | datetime | YES | - | (Documentar) |
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

