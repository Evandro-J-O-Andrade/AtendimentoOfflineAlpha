# documento_arquivo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_documento | bigint | NOT NULL | - | (Documentar) |
| formato | enum('PDF' | NOT NULL | - | (Documentar) |
| mime_type | varchar(120) | YES | - | (Documentar) |
| nome_arquivo | varchar(200) | YES | - | (Documentar) |
| tamanho_bytes | bigint | YES | - | (Documentar) |
| sha256 | char(64) | YES | - | (Documentar) |
| storage_uri | varchar(255) | YES | - | (Documentar) |
| conteudo_blob | longblob | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_documento -> documento_emissao.id_documento

## Indices

- KEY (sha256)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

