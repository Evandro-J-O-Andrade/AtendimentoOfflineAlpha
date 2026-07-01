# faturamento_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_conta | bigint | NOT NULL | - | (Documentar) |
| evento | enum('ABERTURA' | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| tipo | enum('ABRIR' | YES | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_conta)
- KEY (id_sessao_usuario)
- KEY (tipo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

