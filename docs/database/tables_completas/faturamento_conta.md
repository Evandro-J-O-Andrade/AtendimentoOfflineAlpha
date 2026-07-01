# faturamento_conta

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_conta | bigint | NOT NULL | - | (Documentar) |
| tipo_conta | enum('FFA' | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_internacao | bigint | YES | - | (Documentar) |
| status | enum('ABERTA' | NOT NULL | - | (Documentar) |
| valor_total | decimal(12 | YES | - | (Documentar) |
| aberta_em | datetime | YES | - | (Documentar) |
| fechada_em | datetime | YES | - | (Documentar) |
| fechado_por | bigint | YES | - | (Documentar) |
| numero_conta | varchar(30) | YES | - | (Documentar) |
| competencia | char(7) | YES | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| total_bruto | decimal(10 | NOT NULL | - | (Documentar) |
| total_desconto | decimal(10 | NOT NULL | - | (Documentar) |
| total_liquido | decimal(10 | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| id_sessao_usuario_criacao | bigint | YES | - | (Documentar) |
| criado_por | bigint | YES | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| cancelado_em | datetime | YES | - | (Documentar) |
| cancelado_por | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_conta)
- KEY (id_ffa)
- KEY (numero_conta)
- KEY (competencia)
- KEY (id_senha)
- KEY (id_unidade)
- KEY (id_local_operacional)
- KEY (id_sessao_usuario_criacao)
- KEY (criado_por)
- KEY (cancelado_por)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

