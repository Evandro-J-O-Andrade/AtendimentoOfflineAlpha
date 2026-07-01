# pedido_medico_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_pedido_item | bigint | NOT NULL | - | (Documentar) |
| id_pedido_medico | bigint | NOT NULL | - | (Documentar) |
| tipo_item | enum('PROCEDIMENTO' | NOT NULL | - | (Documentar) |
| status | enum('PENDENTE' | NOT NULL | - | (Documentar) |
| codigo_sigtap | varchar(30) | YES | - | (Documentar) |
| competencia_sigtap | char(6) | YES | - | (Documentar) |
| cid10_principal | varchar(10) | YES | - | (Documentar) |
| cnes_executante | varchar(20) | YES | - | (Documentar) |
| id_codigo_universal | bigint | YES | - | (Documentar) |
| sistema_externo | varchar(50) | YES | - | (Documentar) |
| codigo_externo | varchar(80) | YES | - | (Documentar) |
| descricao | varchar(500) | YES | - | (Documentar) |
| prioridade | tinyint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| exige_cat | tinyint(1) | NOT NULL | - | (Documentar) |
| exige_sinan | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (sistema_externo,codigo_externo)

## Indices

- PRIMARY KEY (id_pedido_item)
- KEY (sistema_externo,codigo_externo)
- KEY (id_pedido_medico)
- KEY (tipo_item)
- KEY (status)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

