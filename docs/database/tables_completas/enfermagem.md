# enfermagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| coren | varchar(20) | NOT NULL | - | (Documentar) |
| uf_coren | char(2) | NOT NULL | - | (Documentar) |
| tipo | enum('ENFERMEIRO' | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (coren,uf_coren)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_usuario)
- KEY (coren,uf_coren)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

