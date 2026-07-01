# runtime_estado_sobrevivencia

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_estado | bigint | NOT NULL | - | (Documentar) |
| runtime_device_id | varchar(100) | NOT NULL | - | (Documentar) |
| modo_operacao | enum('NORMAL' | YES | - | (Documentar) |
| ultima_sincronizacao | datetime(6) | YES | - | (Documentar) |
| hash_snapshot_runtime | char(64) | YES | - | (Documentar) |
| evento_seguranca | json | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (runtime_device_id)

## Indices

- PRIMARY KEY (id_estado)
- KEY (runtime_device_id)
- KEY (modo_operacao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

