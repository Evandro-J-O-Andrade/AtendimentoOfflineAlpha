# gpat_atendimento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_gpat | bigint | NOT NULL | - | (Documentar) |
| codigo | varchar(30) | NOT NULL | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| id_cliente | bigint | NOT NULL | - | (Documentar) |
| tipo_prescritor | enum('INTERNO' | NOT NULL | - | (Documentar) |
| id_usuario_medico | bigint | YES | - | (Documentar) |
| id_prescritor_externo | bigint | YES | - | (Documentar) |
| data_emissao | date | YES | - | (Documentar) |
| data_validade | date | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_sessao_abertura | bigint | YES | - | (Documentar) |
| id_sessao_fechamento | bigint | YES | - | (Documentar) |
| id_usuario_abertura | bigint | YES | - | (Documentar) |
| id_usuario_fechamento | bigint | YES | - | (Documentar) |
| id_atendimento | bigint | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (codigo)
- Estrangeira: id_atendimento -> atendimento.id_atendimento
- Estrangeira: id_entidade -> saas_entidade.id_entidade
- Estrangeira: id_cliente -> cliente.id_cliente
- Estrangeira: id_prescritor_externo -> prescritor_externo.id_prescritor_externo
- Estrangeira: id_usuario_medico -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_gpat)
- KEY (codigo)
- KEY (status)
- KEY (id_cliente)
- KEY (id_prescritor_externo)
- KEY (id_usuario_medico)
- KEY (id_sessao_abertura)
- KEY (id_sessao_fechamento)
- KEY (id_atendimento)
- KEY (id_entidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

