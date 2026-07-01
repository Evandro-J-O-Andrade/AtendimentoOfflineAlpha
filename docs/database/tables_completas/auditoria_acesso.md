# auditoria_acesso

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_auditoria_acesso | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| recurso | varchar(120) | NOT NULL | - | (Documentar) |
| acao | enum('READ' | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| ip | varchar(60) | YES | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario

## Indices

- PRIMARY KEY (id_auditoria_acesso)
- KEY (id_sessao_usuario)
- KEY (id_usuario)
- KEY (recurso)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

