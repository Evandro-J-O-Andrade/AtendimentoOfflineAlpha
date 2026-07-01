# documento_emissao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_documento | bigint | NOT NULL | - | (Documentar) |
| id_ffa | bigint | YES | - | (Documentar) |
| id_paciente | bigint | YES | - | (Documentar) |
| id_senha | bigint | YES | - | (Documentar) |
| gpat | varchar(30) | YES | - | (Documentar) |
| tipo_documento | varchar(60) | NOT NULL | - | (Documentar) |
| entidade_ref | varchar(30) | YES | - | (Documentar) |
| id_ref | bigint | YES | - | (Documentar) |
| numero_documento | varchar(40) | YES | - | (Documentar) |
| hash_documento | varchar(64) | YES | - | (Documentar) |
| status | enum('GERADO' | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| id_usuario | bigint | NOT NULL | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (tipo_documento,entidade_ref,id_ref)
- Estrangeira: id_unidade -> unidade.id_unidade

## Indices

- PRIMARY KEY (id_documento)
- KEY (tipo_documento,entidade_ref,id_ref)
- KEY (id_ffa)
- KEY (id_paciente)
- KEY (tipo_documento)
- KEY (status)
- KEY (gpat)
- KEY (criado_em)
- KEY (id_sessao_usuario)
- KEY (id_unidade)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

