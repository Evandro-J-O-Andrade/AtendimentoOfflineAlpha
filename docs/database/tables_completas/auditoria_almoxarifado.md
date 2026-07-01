# auditoria_almoxarifado

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_log | bigint | NOT NULL | - | (Documentar) |
| id_produto | bigint | NOT NULL | - | (Documentar) |
| id_local | bigint | YES | - | (Documentar) |
| acao | enum('ENTRADA' | YES | - | (Documentar) |
| quantidade | int | NOT NULL | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_produto -> produtos_almoxarifado.id_produto
- Estrangeira: id_local -> local_atendimento.id_local
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_log)
- KEY (id_produto)
- KEY (id_local)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

