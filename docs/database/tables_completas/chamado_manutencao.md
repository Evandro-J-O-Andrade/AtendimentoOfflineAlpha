# chamado_manutencao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_chamado | bigint | NOT NULL | - | (Documentar) |
| id_setor | int | NOT NULL | - | (Documentar) |
| origem | enum('PA' | NOT NULL | - | (Documentar) |
| tipo_problema | enum('ELETRICO' | NOT NULL | - | (Documentar) |
| descricao | text | NOT NULL | - | (Documentar) |
| prioridade | enum('BAIXA' | YES | - | (Documentar) |
| status | enum('ABERTO' | YES | - | (Documentar) |
| aberto_por | bigint | NOT NULL | - | (Documentar) |
| aberto_em | datetime | YES | - | (Documentar) |
| fechado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_chamado)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

