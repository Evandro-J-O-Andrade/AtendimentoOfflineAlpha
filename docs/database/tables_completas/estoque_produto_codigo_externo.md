# estoque_produto_codigo_externo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_codigo_ext | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| sistema_externo | enum('SIGTAP' | NOT NULL | - | (Documentar) |
| codigo_externo | varchar(80) | NOT NULL | - | (Documentar) |
| preferencial | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_produto,sistema_externo,codigo_externo)
- Estrangeira: id_produto -> estoque_produto.id_produto

## Indices

- PRIMARY KEY (id_codigo_ext)
- KEY (id_produto,sistema_externo,codigo_externo)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

