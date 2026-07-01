# lab_pedido

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pedido | bigint | NOT NULL | - | (Documentar) |
| protocolo_interno | varchar(30) | NOT NULL | - | (Documentar) |
| id_senha | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | YES | - | (Documentar) |
| id_laboratorio | int | NOT NULL | - | (Documentar) |
| status | enum('SOLICITADO' | YES | - | (Documentar) |
| impresso | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (protocolo_interno)

## Indices

- PRIMARY KEY (id_pedido)
- KEY (protocolo_interno)
- KEY (id_senha)
- KEY (id_ffa)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

