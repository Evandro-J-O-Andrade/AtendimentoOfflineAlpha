# estoque_alerta

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_alerta | bigint | NOT NULL | - | (Documentar) |
| id_saldo | bigint | NOT NULL | - | (Documentar) |
| tipo_alerta | enum('BAIXO' | NOT NULL | - | (Documentar) |
| gerado_em | datetime | NOT NULL | - | (Documentar) |
| resolvido | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_saldo -> estoque_produto_saldo.id_saldo

## Indices

- PRIMARY KEY (id_alerta)
- KEY (id_saldo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

