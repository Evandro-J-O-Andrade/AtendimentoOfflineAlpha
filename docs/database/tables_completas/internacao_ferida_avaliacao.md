# internacao_ferida_avaliacao

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_internacao_ferida_avaliacao | bigint | NOT NULL | - | (Documentar) |
| id_internacao | bigint | NOT NULL | - | (Documentar) |
| data_hora | datetime | NOT NULL | - | (Documentar) |
| tipo | enum('FERIDA' | NOT NULL | - | (Documentar) |
| local_anatomico | varchar(120) | NOT NULL | - | (Documentar) |
| estagio_lpp | enum('I' | YES | - | (Documentar) |
| tamanho_cm | varchar(60) | YES | - | (Documentar) |
| aspecto | varchar(120) | YES | - | (Documentar) |
| exsudato | enum('AUSENTE' | YES | - | (Documentar) |
| odor | enum('NAO' | YES | - | (Documentar) |
| dor | enum('NAO' | YES | - | (Documentar) |
| curativo | text | YES | - | (Documentar) |
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

- PRIMARY KEY (id_internacao_ferida_avaliacao)
- KEY (id_internacao)
- KEY (data_hora)
- KEY (id_usuario_responsavel)
- KEY (id_sessao_usuario)
- KEY (id_documento)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

