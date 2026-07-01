# config_locais

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | int | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(100) | NOT NULL | - | (Documentar) |
| tipo | enum('RECEPCAO' | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

