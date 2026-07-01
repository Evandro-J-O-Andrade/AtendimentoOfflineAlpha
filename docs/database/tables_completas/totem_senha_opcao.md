# totem_senha_opcao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_opcao | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(30) | NOT NULL | - | (Documentar) |
| label | varchar(80) | NOT NULL | - | (Documentar) |
| lane | varchar(20) | NOT NULL | - | (Documentar) |
| tipo_atendimento | varchar(30) | NOT NULL | - | (Documentar) |
| prefixo | varchar(5) | YES | - | (Documentar) |
| ordem | int | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_painel,codigo)
- Estrangeira: id_painel -> painel.id_painel

## Indices

- PRIMARY KEY (id_opcao)
- KEY (id_painel,codigo)
- KEY (id_painel)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

