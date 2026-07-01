# reg_export_lote

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_export_lote | bigint | NOT NULL | - | (Documentar) |
| tipo | enum('SINAN_EPIDEMIOLOGICA' | NOT NULL | - | (Documentar) |
| competencia | char(6) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario_criador | bigint | YES | - | (Documentar) |
| id_unidade | bigint | NOT NULL | - | (Documentar) |
| id_local_operacional | bigint | YES | - | (Documentar) |
| status | enum('ABERTO' | NOT NULL | - | (Documentar) |
| protocolo_externo | varchar(80) | YES | - | (Documentar) |
| observacao | text | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| atualizado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_unidade -> unidade.id_unidade
- Estrangeira: competencia -> md_competencia.competencia
- Estrangeira: id_local_operacional -> local_atendimento.id_local
- Estrangeira: id_usuario_criador -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_export_lote)
- KEY (tipo,status)
- KEY (competencia)
- KEY (criado_em)
- KEY (id_sessao_usuario)
- KEY (id_usuario_criador)
- KEY (id_unidade,id_local_operacional)
- KEY (id_local_operacional)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

