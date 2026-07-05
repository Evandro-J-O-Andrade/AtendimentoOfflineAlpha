# MD-pessoa_documento-colunas — Colunas

## Tabela: `pessoa_documento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_pessoa_documento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_pessoa` | bigint | NOT NULL |
| `tipo_documento` | enum('CPF','RG','CNS','CRM','COREN','CRO','CRF','CNH','PASSAPORTE','PIS','NIS','OUTRO') | NOT NULL |
| `numero` | varchar(50) | NOT NULL |
| `orgao_emissor` | varchar(50) | DEFAULT NULL |
| `uf_emissor` | char(2) | DEFAULT NULL |
| `data_emissao` | date | DEFAULT NULL |
| `data_validade` | date | DEFAULT NULL |
| `principal` | tinyint(1) | DEFAULT '0' |
| `observacao` | varchar(300) | DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_pessoa_documento`),
KEY `idx_doc_pessoa` (`id_pessoa`),
KEY `idx_doc_tipo` (`tipo_documento`),
KEY `idx_doc_numero` (`numero`),
CONSTRAINT `fk_pessoa_documento_pessoa` FOREIGN KEY (`id_pessoa`) REFERENCES `pessoa` (`id_pessoa`)
/*!40000 ALTER TABLE `pessoa_documento` DISABLE KEYS */;
/*!40000 ALTER TABLE `pessoa_documento` ENABLE KEYS */;
