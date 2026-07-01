# totem_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_totem_evento | bigint | NOT NULL | - | (Documentar) |
| id_totem | bigint | NOT NULL | - | (Documentar) |
| evento | enum('ONLINE' | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| ip_acesso | varchar(45) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_totem -> totem.id_totem

## Indices

- PRIMARY KEY (id_totem_evento)
- KEY (id_totem)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

