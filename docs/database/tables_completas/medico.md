# medico

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| crm | varchar(20) | YES | - | (Documentar) |
| uf_crm | char(2) | YES | - | (Documentar) |
| id_especialidade | bigint | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_especialidade -> especialidade.id_especialidade
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_usuario)
- KEY (id_especialidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

