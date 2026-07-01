# runtime_kernel_locks

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | char(36) | NOT NULL | - | (Documentar) |
| locked_by | int | NOT NULL | - | (Documentar) |
| acquired_at | datetime(6) | NOT NULL | - | (Documentar) |
| expires_at | datetime(6) | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id)
- KEY (uuid_runtime,expires_at)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

