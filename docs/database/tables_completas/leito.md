# leito

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_leito | int | NOT NULL | - | (Documentar) |
| id_setor | int | NOT NULL | - | (Documentar) |
| identificacao | varchar(50) | NOT NULL | - | (Documentar) |
| status | enum('DISPONIVEL' | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_setor,identificacao)
- Estrangeira: id_setor -> setor.id_setor

## Indices

- PRIMARY KEY (id_leito)
- KEY (id_setor,identificacao)
- KEY (id_setor,status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

