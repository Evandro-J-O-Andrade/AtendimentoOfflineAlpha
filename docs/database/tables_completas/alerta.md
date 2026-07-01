# alerta

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_alerta | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | NOT NULL | - | (Documentar) |
| titulo | varchar(160) | NOT NULL | - | (Documentar) |
| mensagem | text | YES | - | (Documentar) |
| gpat | varchar(30) | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| severidade | enum('INFO' | NOT NULL | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| entidade_origem | varchar(30) | YES | - | (Documentar) |
| id_origem | bigint | YES | - | (Documentar) |
| id_sessao_usuario_origem | bigint | YES | - | (Documentar) |
| id_usuario_origem | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_paciente -> paciente.id
- Estrangeira: id_usuario_origem -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_alerta)
- KEY (codigo,status)
- KEY (id_unidade,id_local_operacional,status)
- KEY (gpat)
- KEY (id_paciente)
- KEY (id_ffa)
- KEY (id_sessao_usuario_origem)
- KEY (id_usuario_origem)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

