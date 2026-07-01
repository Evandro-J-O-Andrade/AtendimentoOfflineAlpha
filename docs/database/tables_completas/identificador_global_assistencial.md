# identificador_global_assistencial

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_global | bigint | NOT NULL | - | (Documentar) |
| uuid_assistencial | char(36) | NOT NULL | - | (Documentar) |
| tipo_entidade | varchar(60) | NOT NULL | - | (Documentar) |
| hash_imutavel | char(64) | NOT NULL | - | (Documentar) |
| origem_runtime | varchar(120) | NOT NULL | - | (Documentar) |
| bloqueado | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (uuid_assistencial)

## Indices

- PRIMARY KEY (id_global)
- KEY (uuid_assistencial)
- KEY (tipo_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

