# config_leitos

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | int | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| identificacao | varchar(50) | NOT NULL | - | (Documentar) |
| tipo | enum('OBSERVACAO' | YES | - | (Documentar) |
| status_ocupacao | enum('LIVRE' | YES | - | (Documentar) |
| id_atendimento_atual | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

