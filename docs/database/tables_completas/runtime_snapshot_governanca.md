# runtime_snapshot_governanca

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_governanca | bigint | NOT NULL | - | (Documentar) |
| dominio_fluxo | varchar(50) | NOT NULL | - | (Documentar) |
| ttl_snapshot_horas | int | NOT NULL | - | (Documentar) |
| tolerancia_execucao_horas | int | NOT NULL | - | (Documentar) |
| exigir_revalidacao_expirada | tinyint(1) | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| atualizado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (dominio_fluxo)

## Indices

- PRIMARY KEY (id_governanca)
- KEY (dominio_fluxo)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

