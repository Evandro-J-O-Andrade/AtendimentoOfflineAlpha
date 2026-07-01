# senha_sequencia

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| data_ref | date | NOT NULL | - | (Documentar) |
| prefixo | varchar(5) | NOT NULL | - | (Documentar) |
| ultimo_numero | int | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

