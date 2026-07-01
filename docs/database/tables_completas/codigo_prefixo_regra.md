# codigo_prefixo_regra

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_regra | bigint | NOT NULL | - | (Documentar) |
| tipo | varchar(30) | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| prefixo5 | char(5) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (tipo,id_unidade,id_local_operacional)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_regra)
- KEY (tipo,id_unidade,id_local_operacional)
- KEY (tipo)
- KEY (prefixo5)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

