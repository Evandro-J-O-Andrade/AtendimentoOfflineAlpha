# estoque_local

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_estoque_local | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(60) | NOT NULL | - | (Documentar) |
| tipo | enum('FARMACIA_RUA' | NOT NULL | - | (Documentar) |
| ala | enum('ADULTO' | YES | - | (Documentar) |
| nome | varchar(200) | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo,id_unidade)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_estoque_local)
- KEY (codigo,id_unidade)
- KEY (id_sessao_usuario)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

