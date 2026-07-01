# chamado

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_chamado | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_sistema | bigint | NOT NULL | - | (Documentar) |
| area_responsavel | enum('TI' | NOT NULL | - | (Documentar) |
| prioridade | enum('BAIXA' | NOT NULL | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| titulo | varchar(150) | NOT NULL | - | (Documentar) |
| descricao | text | YES | - | (Documentar) |
| id_usuario_abertura | bigint | NOT NULL | - | (Documentar) |
| id_usuario_atribuido | bigint | YES | - | (Documentar) |
| glpi_ticket_id | bigint | YES | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_sistema -> sistema.id_sistema
- Estrangeira: id_usuario_abertura -> usuario.id_usuario
- Estrangeira: id_usuario_atribuido -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_chamado)
- KEY (area_responsavel,status)
- KEY (glpi_ticket_id)
- KEY (id_unidade)
- KEY (id_sistema)
- KEY (id_usuario_abertura)
- KEY (id_usuario_atribuido)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

