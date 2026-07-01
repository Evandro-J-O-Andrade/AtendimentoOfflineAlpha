# ffa

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_paciente | bigint | NOT NULL | - | (Documentar) |
| estado_clinico | enum('AGUARDANDO_TRIAGEM' | NOT NULL | - | (Documentar) |
| contexto_fluxo | json | YES | - | (Documentar) |
| versao_ledger | bigint | YES | - | (Documentar) |
| id_sessao_usuario_abertura | bigint | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| fechado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_ffa)
- KEY (id_paciente)
- KEY (estado_clinico)
- KEY (id_unidade)
- KEY (id_entidade,id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

