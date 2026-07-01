# gasoterapia_consumo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_leito | int | NOT NULL | - | (Documentar) |
| tipo_gas | enum('OXIGENIO' | NOT NULL | - | (Documentar) |
| litros_por_minuto | decimal(10 | NOT NULL | - | (Documentar) |
| data_inicio | datetime | NOT NULL | - | (Documentar) |
| data_fim | datetime | YES | - | (Documentar) |
| status | enum('EM_USO' | YES | - | (Documentar) |
| id_usuario_registro | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_leito -> leito.id_leito

## Indices

- PRIMARY KEY (id)
- KEY (id_atendimento)
- KEY (id_leito)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

