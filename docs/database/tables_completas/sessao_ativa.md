# sessao_ativa

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| token_sessao | varchar(255) | NOT NULL | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| ultimo_clique | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (token_sessao)

## Indices

- PRIMARY KEY (id_usuario)
- KEY (token_sessao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

