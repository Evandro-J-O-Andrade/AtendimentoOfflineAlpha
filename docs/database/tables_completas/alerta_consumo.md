# alerta_consumo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_alerta_consumo | bigint | NOT NULL | - | (Documentar) |
| id_alerta | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| acao | enum('LIDO' | NOT NULL | - | (Documentar) |
| observacao | varchar(240) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (id_alerta,id_usuario)
- Estrangeira: id_alerta -> alerta.id_alerta
- Estrangeira: id_sessao_usuario -> sessao_usuario.id_sessao_usuario
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_alerta_consumo)
- KEY (id_alerta,id_usuario)
- KEY (id_alerta)
- KEY (id_usuario)
- KEY (acao)
- KEY (id_sessao_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

