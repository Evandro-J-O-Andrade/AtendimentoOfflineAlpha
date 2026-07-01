# usuario_log_acesso

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_log | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| ip | varchar(45) | NOT NULL | - | (Documentar) |
| user_agent | varchar(255) | YES | - | (Documentar) |
| sucesso | tinyint(1) | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario
- Estrangeira: id_entidade -> saas_entidade.id_entidade

## Indices

- PRIMARY KEY (id_log)
- KEY (id_usuario)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

