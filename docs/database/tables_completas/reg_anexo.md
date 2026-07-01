# reg_anexo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_anexo | bigint | NOT NULL | - | (Documentar) |
| entidade_ref | varchar(80) | NOT NULL | - | (Documentar) |
| id_ref | bigint | NOT NULL | - | (Documentar) |
| categoria | enum('SINAN' | NOT NULL | - | (Documentar) |
| nome_arquivo | varchar(200) | NOT NULL | - | (Documentar) |
| mime_type | varchar(120) | YES | - | (Documentar) |
| tamanho_bytes | bigint | YES | - | (Documentar) |
| sha256 | char(64) | YES | - | (Documentar) |
| storage_uri | varchar(255) | YES | - | (Documentar) |
| conteudo_blob | longblob | YES | - | (Documentar) |
| id_sessao_usuario | bigint | YES | - | (Documentar) |
| id_usuario | bigint | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_usuario -> usuario.id_usuario

## Indices

- PRIMARY KEY (id_anexo)
- KEY (entidade_ref,id_ref)
- KEY (sha256)
- KEY (id_sessao_usuario)
- KEY (id_usuario)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

