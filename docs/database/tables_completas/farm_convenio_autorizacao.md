# farm_convenio_autorizacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_autorizacao | bigint | NOT NULL | - | (Documentar) |
| id_dispensacao | bigint | NOT NULL | - | (Documentar) |
| numero_autorizacao | varchar(80) | YES | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_dispensacao -> farm_dispensacao.id_dispensacao

## Indices

- PRIMARY KEY (id_autorizacao)
- KEY (id_dispensacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

