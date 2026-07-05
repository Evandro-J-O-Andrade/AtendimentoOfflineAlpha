# MD-documento_arquivo-colunas — Colunas

## Tabela: `documento_arquivo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_documento` | bigint | NOT NULL |
| `formato` | enum('PDF','XML','OUTRO') | NOT NULL DEFAULT 'PDF' |
| `mime_type` | varchar(120) | DEFAULT NULL |
| `nome_arquivo` | varchar(200) | DEFAULT NULL |
| `tamanho_bytes` | bigint | DEFAULT NULL |
| `sha256` | char(64) | DEFAULT NULL |
| `storage_uri` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_documento`,`formato`),
KEY `idx_doc_arq_sha` (`sha256`),
CONSTRAINT `fk_doc_arq_documento` FOREIGN KEY (`id_documento`) REFERENCES `documento_emissao` (`id_documento`)
/*!40000 ALTER TABLE `documento_arquivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `documento_arquivo` ENABLE KEYS */;
