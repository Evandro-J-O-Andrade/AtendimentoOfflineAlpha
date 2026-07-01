# laboratorio_protocolo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_laboratorio_protocolo | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| id_pedido_item | bigint | NOT NULL | - | (Documentar) |
| id_codigo_universal | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | NOT NULL | - | (Documentar) |
| barcode | varchar(60) | NOT NULL | - | (Documentar) |
| status | enum('GERADO' | NOT NULL | - | (Documentar) |
| sistema_externo | varchar(50) | YES | - | (Documentar) |
| codigo_externo | varchar(80) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)
- Unica: UNIQUE KEY (id_pedido_item)

## Indices

- PRIMARY KEY (id_laboratorio_protocolo)
- KEY (codigo)
- KEY (id_pedido_item)
- KEY (id_ffa)
- KEY (id_gpat)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

