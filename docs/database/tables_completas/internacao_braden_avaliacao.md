# internacao_braden_avaliacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_braden_avaliacao | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | NOT NULL | - | (Documentar) |
| percepcao_sensorial | tinyint | NOT NULL | - | (Documentar) |
| umidade | tinyint | NOT NULL | - | (Documentar) |
| atividade | tinyint | NOT NULL | - | (Documentar) |
| mobilidade | tinyint | NOT NULL | - | (Documentar) |
| nutricao | tinyint | NOT NULL | - | (Documentar) |
| friccao_cisalhamento | tinyint | NOT NULL | - | (Documentar) |
| score_total | tinyint | NOT NULL | - | (Documentar) |
| risco | enum('SEM_RISCO' | NOT NULL | - | (Documentar) |
| observacoes | text | YES | - | (Documentar) |
| id_documento | bigint | YES | - | (Documentar) |
| id_usuario_responsavel | bigint | NOT NULL | - | (Documentar) |
| id_sessao_usuario | bigint | NOT NULL | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_documento -> documento_emissao.id_documento
- Estrangeira: id_internacao -> internacao.id_internacao
- Estrangeira: id_usuario_responsavel -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_internacao_braden_avaliacao)
- KEY (id_internacao)
- KEY (data_hora)
- KEY (id_usuario_responsavel)
- KEY (id_sessao_usuario)
- KEY (id_documento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

