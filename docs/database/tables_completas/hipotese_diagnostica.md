# hipotese_diagnostica

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_hipotese | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| cid10 | varchar(10) | YES | - | (Documentar) |
| principal | tinyint(1) | YES | - | (Documentar) |
| id_medico | bigint | YES | - | (Documentar) |
| data_hora | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_medico -> medico.id_usuario

## Indices

- PRIMARY KEY (id_hipotese)
- KEY (id_atendimento)
- KEY (id_medico)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

