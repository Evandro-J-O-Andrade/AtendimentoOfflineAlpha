# atendimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_saas_entidade | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_profissional_responsavel | bigint | YES | - | (Documentar) |
| tipo_atendimento | enum('AMBULATORIAL' | NOT NULL | - | (Documentar) |
| modo_entrada | enum('LOCAL' | NOT NULL | - | (Documentar) |
| status_execucao | enum('INICIADO' | NOT NULL | - | (Documentar) |
| id_faturamento_guia | varchar(50) | YES | - | (Documentar) |
| id_sessao_usuario_criacao | bigint | YES | - | (Documentar) |
| id_sessao_usuario_alteracao | bigint | YES | - | (Documentar) |
| uuid_sync | char(36) | NOT NULL | - | (Documentar) |
| versao_sync | bigint | YES | - | (Documentar) |
| hash_estado | char(64) | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| finalizado_em | datetime(6) | YES | - | (Documentar) |
| removido_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_ffa -> ffa.id_ffa
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_atendimento)
- KEY (id_ffa)
- KEY (id_saas_entidade,id_unidade)
- KEY (status_execucao)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

