# auditoria_erro

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_auditoria_erro | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| rotina | varchar(128) | YES | - | (Documentar) |
| sqlstate | varchar(10) | YES | - | (Documentar) |
| errno | int | YES | - | (Documentar) |
| mensagem | text | YES | - | (Documentar) |
| contexto | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_auditoria_erro)
- KEY (criado_em)
- KEY (rotina)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

