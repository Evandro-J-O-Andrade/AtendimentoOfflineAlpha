# auditoria_mestre

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| dominio | enum('FILA' | YES | - | (Documentar) |
| acao | varchar(100) | YES | - | (Documentar) |
| tabela_afetada | varchar(100) | YES | - | (Documentar) |
| id_registro | bigint | YES | - | (Documentar) |
| valor_anterior | json | YES | - | (Documentar) |
| valor_novo | json | YES | - | (Documentar) |
| motivo_alteracao | text | YES | - | (Documentar) |
| data_evento | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario

## Indices

- PRIMARY KEY (id)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

