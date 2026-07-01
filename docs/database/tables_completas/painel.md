# painel

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_painel | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(50) | NOT NULL | - | (Documentar) |
| tipo | enum('PAINEL' | NOT NULL | - | (Documentar) |
| nome | varchar(120) | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| tts_habilitado | tinyint(1) | NOT NULL | - | (Documentar) |
| piscada_seg | int | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| intervalo_segundos | int | NOT NULL | - | (Documentar) |
| id_sistema | bigint | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_painel)
- KEY (codigo)
- KEY (id_unidade)
- KEY (id_local_operacional)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

