# caixa

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_caixa | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | NOT NULL | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| aberto_em | datetime | YES | - | (Documentar) |
| fechado_em | datetime | YES | - | (Documentar) |
| aberto_por | bigint | YES | - | (Documentar) |
| fechado_por | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: aberto_por -> usuario.id_usuario
- Estrangeira: fechado_por -> usuario.id_usuario
- Estrangeira: id_local_operacional -> local_operacional.id_local_operacional

## Indices

- PRIMARY KEY (id_caixa)
- KEY (status)
- KEY (id_unidade)
- KEY (id_local_operacional)
- KEY (aberto_por)
- KEY (fechado_por)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

