# auth_grupo_permissao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_grupo_permissao | bigint | NOT NULL | - | (Documentar) |
| id_grupo | bigint | NOT NULL | - | (Documentar) |
| recurso | varchar(100) | NOT NULL | - | (Documentar) |
| acao | varchar(50) | NOT NULL | - | (Documentar) |
| ativo | tinyint(1) | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_grupo,recurso,acao)
- Estrangeira: id_grupo -> auth_grupo.id_grupo

## Indices

- PRIMARY KEY (id_grupo_permissao)
- KEY (id_grupo,recurso,acao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

