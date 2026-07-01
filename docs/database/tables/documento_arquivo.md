# documento_arquivo

Objetivo: Tabela de armazenamento de dados do sistema

DescriÃ§Ã£o: 

## Colunas

| Coluna | Tipo | Nullable | Default | FunÃ§Ã£o/DescriÃ§Ã£o |
|---------|------|----------|---------|------------------|
| id_documento | bigint | NO |  | id documento |
| formato | enum('PDF','XML','OUTRO') | NO | 'PDF' | formato |
| mime_type | varchar(120) | YES | NULL | mime type |
| nome_arquivo | varchar(200) | YES | NULL | nome arquivo |
| tamanho_bytes | bigint | YES | NULL | tamanho bytes |
| sha256 | char(64) | YES | NULL | sha256 |
| storage_uri | varchar(255) | YES | NULL | storage uri |
| conteudo_blob | longblob | YES |  | conteudo blob |
| criado_em | datetime | NO | CURRENT_TIMESTAMP | criado em |
| id_entidade | bigint unsigned | NO |  | id entidade |

## Chaves

- PrimÃ¡ria: .
- Estrangeiras:
  - id_documento referencia documento_emissao.id_documento

## Ãndices

- idx_doc_arq_sha em (sha256)

## Constraints

- FOREIGN KEY (id_documento) REFERENCES documento_emissao(id_documento)

## Relacionamentos e Cardinalidade

- documento_arquivo (id_documento) -> documento_emissao (id_documento): N:1

## DependÃªncias

- Depende de: documento_emissao.

## Fluxo de utilizaÃ§Ã£o dentro do sistema

- Dados sÃ£o inseridos e consultados conforme regras de negÃ³cio associadas.

