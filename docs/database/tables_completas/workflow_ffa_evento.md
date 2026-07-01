# workflow_ffa_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_workflow_evento | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | NOT NULL | - | (Documentar) |
| origem | varchar(20) | NOT NULL | - | (Documentar) |
| entidade | varchar(50) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(60) | NOT NULL | - | (Documentar) |
| detalhe | text | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| payload_json | json | YES | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario

## Indices

- PRIMARY KEY (id_workflow_evento)
- KEY (id_ffa,criado_em)
- KEY (tipo_evento)
- KEY (origem)
- KEY (entidade,id_entidade)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

