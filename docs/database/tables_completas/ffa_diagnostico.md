# ffa_diagnostico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_diagnostico | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| cid10 | varchar(12) | YES | - | (Documentar) |
| descricao | varchar(255) | YES | - | (Documentar) |
| tipo | enum('PRINCIPAL' | NOT NULL | - | (Documentar) |
| confirmado | tinyint | NOT NULL | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_ffa,cid10,tipo)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_diagnostico)
- KEY (id_ffa,cid10,tipo)
- KEY (id_ffa)
- KEY (id_sessao_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

