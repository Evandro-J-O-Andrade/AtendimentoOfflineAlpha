# kernel_runtime_heartbeat

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_heartbeat | bigint | NOT NULL | - | (Documentar) |
| uuid_runtime | char(36) | NOT NULL | - | (Documentar) |
| estado_runtime | varchar(80) | NOT NULL | - | (Documentar) |
| ultimo_ping | datetime(6) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_runtime)

## Indices

- PRIMARY KEY (id_heartbeat)
- KEY (uuid_runtime)
- KEY (estado_runtime)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

