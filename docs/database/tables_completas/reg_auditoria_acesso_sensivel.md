# reg_auditoria_acesso_sensivel

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_acesso | bigint | NOT NULL | - | (Documentar) |
| ocorrido_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| entidade_ref | varchar(80) | NOT NULL | - | (Documentar) |
| id_ref | bigint | NOT NULL | - | (Documentar) |
| acao | enum('VISUALIZAR' | NOT NULL | - | (Documentar) |
| motivo | varchar(255) | YES | - | (Documentar) |
| ip_origem | varchar(60) | YES | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_acesso)
- KEY (ocorrido_em)
- KEY (entidade_ref,id_ref)
- KEY (id_usuario)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

