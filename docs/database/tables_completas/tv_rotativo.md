# tv_rotativo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tv_rotativo | bigint | NOT NULL | - | (Documentar) |
| nome | varchar(80) | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| intervalo_seg | int | NOT NULL | - | (Documentar) |
| ativo | tinyint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| criado_por | bigint | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| atualizado_por | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (nome)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_tv_rotativo)
- KEY (nome)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

