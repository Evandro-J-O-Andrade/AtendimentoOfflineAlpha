# auth_audit

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_audit | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_sessao | bigint | YES | - | (Documentar) |
| acao | varchar(100) | NOT NULL | - | (Documentar) |
| recurso | varchar(100) | YES | - | (Documentar) |
| detalhes | json | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| user_agent | text | YES | - | (Documentar) |
| sucesso | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_audit)
- KEY (id_usuario)
- KEY (id_sessao)
- KEY (acao)
- KEY (criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

