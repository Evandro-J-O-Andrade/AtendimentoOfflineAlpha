# sessao_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_evento | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| tipo_evento | varchar(60) | NOT NULL | - | (Documentar) |
| recurso | varchar(120) | YES | - | (Documentar) |
| payload | json | YES | - | (Documentar) |
| ip_origem | varchar(45) | YES | - | (Documentar) |
| criado_em | datetime(6) | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_evento)
- KEY (id_sessao_usuario)
- KEY (id_usuario)
- KEY (tipo_evento)
- KEY (id_sessao_usuario,criado_em)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

