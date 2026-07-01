# nucleo_governanca_assistencial

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_nucleo | bigint | NOT NULL | - | (Documentar) |
| hash_nucleo_estrutura | char(64) | NOT NULL | - | (Documentar) |
| versao_protocolo | bigint | NOT NULL | - | (Documentar) |
| descricao_release | text | YES | - | (Documentar) |
| estado_nucleo | enum('ATIVO' | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (hash_nucleo_estrutura)

## Indices

- PRIMARY KEY (id_nucleo)
- KEY (hash_nucleo_estrutura)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

