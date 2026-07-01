# tv_rotativo_tela

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_tela | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | NOT NULL | - | (Documentar) |
| codigo_tela | varchar(50) | NOT NULL | - | (Documentar) |
| ordem | int | NOT NULL | - | (Documentar) |
| duracao_seg | int | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_painel,ordem)
- Estrangeira: id_painel -> painel.id_painel

## Indices

- PRIMARY KEY (id_tela)
- KEY (id_painel,ordem)
- KEY (id_painel)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

