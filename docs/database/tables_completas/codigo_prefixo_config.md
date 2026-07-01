# codigo_prefixo_config

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_prefixo | bigint | NOT NULL | - | (Documentar) |
| dominio | enum('LAB' | NOT NULL | - | (Documentar) |
| prefixo_5 | char(5) | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_laboratorio | bigint | YES | - | (Documentar) |
| ativo | tinyint | NOT NULL | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (dominio,prefixo_5,id_unidade,id_local_operacional,id_laboratorio)

## Indices

- PRIMARY KEY (id_prefixo)
- KEY (dominio,prefixo_5,id_unidade,id_local_operacional,id_laboratorio)
- KEY (dominio,ativo,id_unidade,id_local_operacional,id_laboratorio)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

