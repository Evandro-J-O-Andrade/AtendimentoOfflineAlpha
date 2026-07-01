# cidade

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cidade | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(150) | NOT NULL | - | (Documentar) |
| estado | varchar(10) | NOT NULL | - | (Documentar) |
| codigo_ibge | varchar(10) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_cidade)
- KEY (id_entidade)
- KEY (codigo_ibge)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

