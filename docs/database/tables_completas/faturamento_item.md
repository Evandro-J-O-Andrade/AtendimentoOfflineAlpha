# faturamento_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| origem | enum('PROCEDIMENTO' | NOT NULL | - | (Documentar) |
| id_origem | bigint | NOT NULL | - | (Documentar) |
| descricao | varchar(255) | NOT NULL | - | (Documentar) |
| quantidade | decimal(10 | YES | - | (Documentar) |
| valor_unitario | decimal(10 | NOT NULL | - | (Documentar) |
| valor_total | decimal(10 | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_internacao | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| criado_por | bigint | NOT NULL | - | (Documentar) |
| status | enum('ABERTO' | YES | - | (Documentar) |
| id_conta | bigint | YES | - | (Documentar) |
| id_codigo | bigint | YES | - | (Documentar) |
| sistema_codigo | enum('SUS' | NOT NULL | - | (Documentar) |
| codigo | varchar(30) | YES | - | (Documentar) |
| tipo | enum('PROCEDIMENTO' | NOT NULL | - | (Documentar) |
| desconto | decimal(10 | NOT NULL | - | (Documentar) |
| total_linha | decimal(10 | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_codigo -> faturamento_codigo.id_codigo
- Estrangeira: id_conta -> faturamento_conta.id_conta

## Indices

- PRIMARY KEY (id_item)
- KEY (id_conta)
- KEY (id_codigo)
- KEY (codigo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

