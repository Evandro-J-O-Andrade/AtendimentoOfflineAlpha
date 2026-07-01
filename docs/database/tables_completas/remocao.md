# remocao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_remocao | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| origem | varchar(150) | YES | - | (Documentar) |
| destino | varchar(150) | YES | - | (Documentar) |
| motivo | varchar(255) | YES | - | (Documentar) |
| status | enum('SOLICITADA' | NOT NULL | - | (Documentar) |
| id_viatura | bigint | YES | - | (Documentar) |
| condutor_interno | varchar(150) | YES | - | (Documentar) |
| condutor_externo | varchar(150) | YES | - | (Documentar) |
| protocolo_cross | varchar(50) | YES | - | (Documentar) |
| id_usuario_solicitante | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | YES | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario_solicitante -> usuario.id_usuario
- Estrangeira: id_viatura -> viatura.id_viatura
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_remocao)
- KEY (status)
- KEY (id_unidade)
- KEY (id_viatura)
- KEY (id_usuario_solicitante)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

