# painel_monitoramento_especialidade

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_cfg | bigint | NOT NULL | - | (Documentar) |
| id_painel | bigint | NOT NULL | - | (Documentar) |
| id_especialidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| ordem | int | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_painel -> painel.id_painel

## Indices

- PRIMARY KEY (id_cfg)
- KEY (id_painel)
- KEY (id_local_operacional)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

