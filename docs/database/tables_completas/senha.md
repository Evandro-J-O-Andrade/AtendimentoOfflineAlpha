# senha

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_senha | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| codigo_visual | varchar(10) | NOT NULL | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| origem_entrada | enum('RECEPCAO' | NOT NULL | - | (Documentar) |
| id_prioridade | bigint | NOT NULL | - | (Documentar) |
| id_fluxo_status | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| uuid_sync | char(36) | NOT NULL | - | (Documentar) |
| versao_sync | bigint | YES | - | (Documentar) |
| hash_estado | char(64) | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_ffa -> ffa.id_ffa
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_senha)
- KEY (id_paciente)
- KEY (origem_entrada)
- KEY (id_unidade)
- KEY (id_ffa)
- KEY (id_entidade,id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

