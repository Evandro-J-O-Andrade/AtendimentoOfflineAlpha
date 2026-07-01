# kernel_runtime_single_writer_lock

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_lock | bigint | NOT NULL | - | (Documentar) |
| contexto_runtime | varchar(50) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| estado_lock | enum('ATIVO' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)

## Indices

- PRIMARY KEY (id_lock)
- KEY (contexto_runtime)
- KEY (estado_lock)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

