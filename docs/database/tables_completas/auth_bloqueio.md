# auth_bloqueio

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_bloqueio | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo_bloqueio | enum('SENHA_EXPIRADA' | NOT NULL | - | (Documentar) |
| motivo | text | NOT NULL | - | (Documentar) |
| bloqueado_por | bigint | YES | - | (Documentar) |
| expira_em | datetime | YES | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| desbloqueado_por | bigint | YES | - | (Documentar) |
| desbloqueado_em | datetime | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_bloqueio)
- KEY (id_usuario)
- KEY (expira_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

