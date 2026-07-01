# erro_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_erro | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_erro_catalogo | bigint | YES | - | (Documentar) |
| uuid_transacao | char(36) | YES | - | (Documentar) |
| dominio | varchar(50) | YES | - | (Documentar) |
| acao | varchar(100) | YES | - | (Documentar) |
| mensagem_erro | text | NOT NULL | - | (Documentar) |
| stack_trace | json | YES | - | (Documentar) |
| payload_tentativa | json | YES | - | (Documentar) |
| criado_em | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_erro_catalogo -> erro_catalogo.id_erro_catalogo

## Indices

- PRIMARY KEY (id_erro)
- KEY (id_sessao_usuario)
- KEY (criado_em)
- KEY (id_erro_catalogo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

