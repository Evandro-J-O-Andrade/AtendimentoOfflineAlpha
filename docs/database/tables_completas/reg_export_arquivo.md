# reg_export_arquivo

Objetivo: (Documentar)

Descricao: (Documentar)

## Colunas

| Coluna | Tipo | Nullable | Default | Funcao |
|---------|------|----------|---------|--------|
| id_export_arquivo | bigint | NOT NULL | - | (Documentar) |
| id_export_lote | bigint | NOT NULL | - | (Documentar) |
| formato | enum('XML' | NOT NULL | - | (Documentar) |
| mime_type | varchar(120) | YES | - | (Documentar) |
| nome_arquivo | varchar(200) | NOT NULL | - | (Documentar) |
| tamanho_bytes | bigint | YES | - | (Documentar) |
| sha256 | char(64) | YES | - | (Documentar) |
| storage_uri | varchar(255) | YES | - | (Documentar) |
| conteudo_blob | longblob | YES | - | (Documentar) |
| criado_em | datetime | NOT NULL | - | (Documentar) |
| id_entidade | bigint | NOT NULL | - | (Documentar) |

## Chaves

- Primaria: (Documentar)
- Estrangeira: id_export_lote -> reg_export_lote.id_export_lote

## Indices

- PRIMARY KEY (id_export_arquivo)
- KEY (id_export_lote)
- KEY (sha256)

## Dependencias

- (Documentar)

## Fluxo

- (Documentar)

