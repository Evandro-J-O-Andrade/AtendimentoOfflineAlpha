# codigo_universal

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_codigo | bigint | NOT NULL | - | (Documentar) |
| dominio | enum('LAB' | NOT NULL | - | (Documentar) |
| prefixo_5 | char(5) | YES | - | (Documentar) |
| sequencia | int | YES | - | (Documentar) |
| codigo_interno | varchar(50) | NOT NULL | - | (Documentar) |
| barcode | varchar(60) | NOT NULL | - | (Documentar) |
| origem_interno | enum('AUTO' | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_produto | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_cliente | bigint | YES | - | (Documentar) |
| status | enum('ATIVO' | NOT NULL | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo_interno)
- Unica: UNIQUE KEY (barcode)
- Unica: UNIQUE KEY (dominio,prefixo_5,sequencia)
- Estrangeira: id_cliente -> cliente.id_cliente
- Estrangeira: id_paciente -> paciente.id
- Estrangeira: id_produto -> estoque_produto.id_produto
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_codigo)
- KEY (codigo_interno)
- KEY (barcode)
- KEY (dominio,prefixo_5,sequencia)
- KEY (dominio,status,criado_em)
- KEY (id_ffa)
- KEY (id_produto)
- KEY (id_usuario)
- KEY (id_senha)
- KEY (id_paciente)
- KEY (id_cliente)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

