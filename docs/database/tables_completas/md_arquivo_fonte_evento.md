# md_arquivo_fonte_evento

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_md_arquivo_fonte_evento | bigint | NOT NULL | - | (Documentar) |
| id_md_arquivo_fonte | bigint | NOT NULL | - | (Documentar) |
| ocorrido_em | datetime | NOT NULL | - | (Documentar) |
| acao | enum('CRIADO' | NOT NULL | - | (Documentar) |
| detalhes | varchar(500) | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_md_arquivo_fonte -> md_arquivo_fonte.id_md_arquivo_fonte
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_md_arquivo_fonte_evento)
- KEY (id_md_arquivo_fonte)
- KEY (ocorrido_em)
- KEY (id_sessao_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

