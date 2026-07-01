# procedimento_protocolo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_protocolo | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('EXAME' | NOT NULL | - | (Documentar) |
| codigo | varchar(50) | NOT NULL | - | (Documentar) |
| barcode | varchar(50) | NOT NULL | - | (Documentar) |
| status | enum('CRIADO' | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_fila | bigint | NOT NULL | - | (Documentar) |
| id_sessao_criacao | bigint | NOT NULL | - | (Documentar) |
| id_usuario_criacao | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)
- Unica: UNIQUE KEY (id_fila,tipo)
- Estrangeira: id_fila -> fila_operacional.id_fila
- Estrangeira: id_usuario_criacao -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_protocolo)
- KEY (codigo)
- KEY (id_fila,tipo)
- KEY (id_ffa)
- KEY (tipo,status,criado_em)
- KEY (id_sessao_criacao)
- KEY (id_usuario_criacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

