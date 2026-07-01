# codigo_externo_vinculo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_vinculo | bigint | NOT NULL | - | (Documentar) |
| tipo | varchar(30) | NOT NULL | - | (Documentar) |
| sistema_externo | varchar(50) | NOT NULL | - | (Documentar) |
| codigo_externo | varchar(80) | NOT NULL | - | (Documentar) |
| id_codigo_universal | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (tipo,sistema_externo,codigo_externo)

## Indices

- PRIMARY KEY (id_vinculo)
- KEY (tipo,sistema_externo,codigo_externo)
- KEY (id_codigo_universal)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

