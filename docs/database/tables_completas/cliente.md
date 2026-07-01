# cliente

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cliente | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(255) | NOT NULL | - | (Documentar) |
| documento | varchar(30) | YES | - | (Documentar) |
| telefone | varchar(30) | YES | - | (Documentar) |
| email | varchar(150) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (documento)

## Indices

- PRIMARY KEY (id_cliente)
- KEY (documento)
- KEY (nome)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

