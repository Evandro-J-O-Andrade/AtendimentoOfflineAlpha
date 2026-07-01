# agendamento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_agendamento | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | YES | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_profissional | bigint | YES | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| id_servico | bigint | NOT NULL | - | (Documentar) |
| inicio_em | datetime(6) | NOT NULL | - | (Documentar) |
| fim_em | datetime(6) | NOT NULL | - | (Documentar) |
| duracao_minutos | int | YES | - | (Documentar) |
| status | varchar(40) | NOT NULL | - | (Documentar) |
| origem | varchar(40) | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| criado_por | bigint | NOT NULL | - | (Documentar) |
| id_sessao_criacao | bigint | YES | - | (Documentar) |
| uuid_sync | char(36) | NOT NULL | - | (Documentar) |
| versao_sync | bigint | YES | - | (Documentar) |
| hash_estado | char(64) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_paciente -> paciente.id
- Estrangeira: id_profissional -> usuario.id_usuario
- Estrangeira: id_servico -> servico_agendamento.id_servico
- Estrangeira: id_sistema -> sistema.id_sistema
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_ffa -> ffa.id_ffa
- Estrangeira: id_senha -> senha.id_senha
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_agendamento)
- KEY (id_profissional,inicio_em)
- KEY (id_local_operacional,inicio_em)
- KEY (id_paciente,inicio_em)
- KEY (id_ffa,inicio_em)
- KEY (id_senha)
- KEY (id_sistema,id_unidade,inicio_em)
- KEY (id_servico)
- KEY (id_sessao_criacao)
- KEY (id_unidade)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

