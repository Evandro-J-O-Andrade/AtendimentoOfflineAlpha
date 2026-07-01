# assistencial_circuit_breaker

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_circuit | bigint | NOT NULL | - | (Documentar) |
| componente | varchar(60) | NOT NULL | - | (Documentar) |
| estado | enum('FECHADO' | YES | - | (Documentar) |
| falhas_consecutivas | int | YES | - | (Documentar) |
| limite_falha | int | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (componente)

## Indices

- PRIMARY KEY (id_circuit)
- KEY (componente)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

