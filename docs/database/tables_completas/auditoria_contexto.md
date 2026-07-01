# auditoria_contexto

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | NOT NULL | - | (Documentar) |
| acao | varchar(60) | NOT NULL | - | (Documentar) |
| detalhes | json | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_local -> local.id_local
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id)
- KEY (id_sessao_usuario)
- KEY (id_usuario,criado_em)
- KEY (id_entidade,id_unidade)
- KEY (id_atendimento)
- KEY (id_local)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

