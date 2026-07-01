# sala_notificacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_notificacao | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| tipo | enum('VIOLENCIA' | NOT NULL | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| detalhes | text | YES | - | (Documentar) |
| id_usuario_abertura | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: id_usuario_abertura -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_notificacao)
- KEY (id_unidade)
- KEY (id_usuario_abertura)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

