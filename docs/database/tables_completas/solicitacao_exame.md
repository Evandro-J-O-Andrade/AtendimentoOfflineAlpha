# solicitacao_exame

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_solicitacao | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_exame | int | YES | - | (Documentar) |
| id_sigpat | bigint | YES | - | (Documentar) |
| status | enum('SOLICITADO' | NOT NULL | - | (Documentar) |
| id_medico | bigint | YES | - | (Documentar) |
| solicitado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_exame -> exame.id_exame
- Estrangeira: id_medico -> medico.id_usuario

## Indices

- PRIMARY KEY (id_solicitacao)
- KEY (id_atendimento)
- KEY (id_exame)
- KEY (id_medico)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

