# kernel_ledger

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_transacao | varchar(36) | NOT NULL | - | (Documentar) |
| id_sessao | bigint | YES | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_perfil | bigint | NOT NULL | - | (Documentar) |
| acao | varchar(100) | NOT NULL | - | (Documentar) |
| contexto | varchar(60) | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| status | varchar(20) | NOT NULL | - | (Documentar) |
| duracao_ms | int | YES | - | (Documentar) |
| mensagem | text | YES | - | (Documentar) |
| id_tenant | bigint | YES | - | (Documentar) |
| registrado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_transacao)
- KEY (id_usuario,registrado_em)
- KEY (acao,registrado_em)
- KEY (contexto,registrado_em)
- KEY (status,registrado_em)
- KEY (id_tenant,registrado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

