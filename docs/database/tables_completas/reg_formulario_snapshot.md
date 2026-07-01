# reg_formulario_snapshot

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_snapshot | bigint | NOT NULL | - | (Documentar) |
| entidade_ref | varchar(80) | NOT NULL | - | (Documentar) |
| id_ref | bigint | NOT NULL | - | (Documentar) |
| tipo_formulario | varchar(80) | NOT NULL | - | (Documentar) |
| versao_layout | varchar(40) | YES | - | (Documentar) |
| competencia | char(6) | YES | - | (Documentar) |
| payload_json | json | NOT NULL | - | (Documentar) |
| payload_hash | char(64) | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario_criador | bigint | YES | - | (Documentar) |
| sigilo_nivel | enum('NORMAL' | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Unica: UNIQUE KEY (entidade_ref,id_ref,tipo_formulario,versao_layout)
- Estrangeira: competencia -> md_competencia.competencia
- Estrangeira: id_usuario_criador -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_snapshot)
- KEY (entidade_ref,id_ref,tipo_formulario,versao_layout)
- KEY (payload_hash)
- KEY (competencia)
- KEY (id_sessao_usuario)
- KEY (id_usuario_criador)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

