# codigo_externo_map

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_map | bigint | NOT NULL | - | (Documentar) |
| id_codigo | bigint | NOT NULL | - | (Documentar) |
| dominio | enum('LAB' | NOT NULL | - | (Documentar) |
| sistema_externo | varchar(50) | NOT NULL | - | (Documentar) |
| codigo_externo | varchar(80) | NOT NULL | - | (Documentar) |
| modo_cadastro | enum('AUTO' | NOT NULL | - | (Documentar) |
| observacao | varchar(255) | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (dominio,sistema_externo,codigo_externo)
- Estrangeira: id_codigo -> codigo_universal.id_codigo

## Indices

- PRIMARY KEY (id_map)
- KEY (dominio,sistema_externo,codigo_externo)
- KEY (id_codigo)
- KEY (dominio,sistema_externo)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

