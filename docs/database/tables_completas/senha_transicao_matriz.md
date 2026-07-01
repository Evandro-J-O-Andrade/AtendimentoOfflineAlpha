# senha_transicao_matriz

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_senha_transicao | bigint | NOT NULL | - | (Documentar) |
| id_status_origem | bigint | NOT NULL | - | (Documentar) |
| id_status_destino | bigint | NOT NULL | - | (Documentar) |
| permite_retorno | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_status_origem,id_status_destino)
- Estrangeira: id_status_origem -> senha_status.id_senha_status
- Estrangeira: id_status_destino -> senha_status.id_senha_status

## Indices

- PRIMARY KEY (id_senha_transicao)
- KEY (id_status_origem,id_status_destino)
- KEY (id_status_destino)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

