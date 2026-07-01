# exame_pedido

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pedido | bigint | NOT NULL | - | (Documentar) |
| codigo_interno | varchar(30) | NOT NULL | - | (Documentar) |
| id_senha | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| status | enum('SOLICITADO' | YES | - | (Documentar) |
| id_usuario_solicitante | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_interno)

## Indices

- PRIMARY KEY (id_pedido)
- KEY (codigo_interno)
- KEY (id_senha)
- KEY (id_ffa)
- KEY (id_atendimento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

