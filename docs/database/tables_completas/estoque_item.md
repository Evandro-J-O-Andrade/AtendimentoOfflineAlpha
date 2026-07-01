# estoque_item

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_item | bigint | NOT NULL | - | (Documentar) |
| codigo_interno | varchar(50) | YES | - | (Documentar) |
| codigo_barras | varchar(128) | YES | - | (Documentar) |
| codigo_tuss | varchar(20) | YES | - | (Documentar) |
| nome_comercial | varchar(255) | NOT NULL | - | (Documentar) |
| categoria | enum('MEDICAMENTO' | NOT NULL | - | (Documentar) |
| unidade_venda | varchar(10) | NOT NULL | - | (Documentar) |
| is_faturavel | tinyint(1) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | timestamp | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_interno)
- Unica: UNIQUE KEY (codigo_barras)

## Indices

- PRIMARY KEY (id_item)
- KEY (codigo_interno)
- KEY (codigo_barras)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

