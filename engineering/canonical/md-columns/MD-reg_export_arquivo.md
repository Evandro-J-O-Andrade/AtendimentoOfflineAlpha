# MD-reg_export_arquivo-colunas — Colunas

## Tabela: `reg_export_arquivo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_export_arquivo` | bigint | NOT NULL AUTO_INCREMENT |
| `id_export_lote` | bigint | NOT NULL |
| `formato` | enum('XML','PDF','JSON','CSV','ZIP','OUTRO') | NOT NULL |
| `mime_type` | varchar(120) | DEFAULT NULL |
| `nome_arquivo` | varchar(200) | NOT NULL |
| `tamanho_bytes` | bigint | DEFAULT NULL |
| `sha256` | char(64) | DEFAULT NULL |
| `storage_uri` | varchar(255) | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_export_arquivo`),
KEY `idx_reg_arq_lote` (`id_export_lote`),
KEY `idx_reg_arq_sha` (`sha256`),
CONSTRAINT `fk_reg_arq_lote` FOREIGN KEY (`id_export_lote`) REFERENCES `reg_export_lote` (`id_export_lote`)
/*!40000 ALTER TABLE `reg_export_arquivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `reg_export_arquivo` ENABLE KEYS */;
