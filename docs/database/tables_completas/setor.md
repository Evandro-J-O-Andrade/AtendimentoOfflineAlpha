# setor

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_setor | int | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(100) | NOT NULL | - | (Documentar) |
| tipo | enum('PRONTO_SOCORRO' | NOT NULL | - | (Documentar) |
| ramal | varchar(10) | YES | - | (Documentar) |
| responsavel_id | bigint | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_setor)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

