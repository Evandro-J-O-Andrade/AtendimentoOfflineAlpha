# alerta_destinatario

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_alerta_destinatario | bigint | NOT NULL | - | (Documentar) |
| id_alerta | bigint | NOT NULL | - | (Documentar) |
| tipo_destino | enum('USUARIO' | NOT NULL | - | (Documentar) |
| codigo_destino | varchar(60) | YES | - | (Documentar) |
| id_destino | bigint | YES | - | (Documentar) |
| status | enum('NOVO' | NOT NULL | - | (Documentar) |
| lido_em | datetime | YES | - | (Documentar) |
| id_sessao_usuario_acao | bigint | YES | - | (Documentar) |
| id_usuario_acao | bigint | YES | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_alerta -> alerta.id_alerta
- Estrangeira: id_usuario_acao -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_alerta_destinatario)
- KEY (id_alerta)
- KEY (tipo_destino,codigo_destino,status)
- KEY (tipo_destino,id_destino,status)
- KEY (lido_em)
- KEY (id_sessao_usuario_acao)
- KEY (id_usuario_acao)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

