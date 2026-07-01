# ffa_substatus

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| categoria | enum('MEDICACAO' | NOT NULL | - | (Documentar) |
| status | varchar(50) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| finalizado_em | datetime | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id)
- KEY (id_usuario)
- KEY (id_ffa,categoria,ativo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

