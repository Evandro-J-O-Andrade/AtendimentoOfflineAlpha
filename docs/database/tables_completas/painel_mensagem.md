# painel_mensagem

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_mensagem | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('ALERTA' | NOT NULL | - | (Documentar) |
| titulo | varchar(120) | YES | - | (Documentar) |
| texto | text | NOT NULL | - | (Documentar) |
| prioridade | int | NOT NULL | - | (Documentar) |
| expira_em | datetime | YES | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| criado_por | bigint | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_painel -> painel.id_painel

## Indices

- PRIMARY KEY (id_mensagem)
- KEY (id_painel,ativo,criado_em)
- KEY (expira_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

