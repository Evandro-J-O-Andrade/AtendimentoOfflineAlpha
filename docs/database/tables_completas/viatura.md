# viatura

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_viatura | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| prefixo | varchar(30) | NOT NULL | - | (Documentar) |
| tipo | enum('AMBULANCIA_BASICA' | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_unidade,prefixo)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_viatura)
- KEY (id_unidade,prefixo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

