# runtime_contexto

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_runtime_contexto | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| contexto_clinico | varchar(60) | YES | - | (Documentar) |
| estado_fluxo | varchar(60) | YES | - | (Documentar) |
| iniciado_em | datetime(6) | YES | - | (Documentar) |
| finalizado_em | datetime(6) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario

## Indices

- PRIMARY KEY (id_runtime_contexto)
- KEY (id_sessao_usuario)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

