# unidade

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| id_cidade | bigint | YES | - | (Documentar) |
| nome | varchar(200) | YES | - | (Documentar) |
| tipo | varchar(100) | YES | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_cidade -> cidade.id_cidade
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_unidade)
- KEY (id_entidade)
- KEY (id_cidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

