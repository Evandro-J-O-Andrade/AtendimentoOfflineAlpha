# MD-estoque_audit_stream-colunas — Colunas

## Tabela: `estoque_audit_stream`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_audit` | bigint | NOT NULL AUTO_INCREMENT |
| `id_referencia_externa` | bigint | DEFAULT NULL |
| `entidade_tipo` | enum('ESTOQUE','FATURAMENTO','ASSISTENCIAL') | NOT NULL |
| `evento_tipo` | varchar(50) | DEFAULT NULL |
| `payload` | json | DEFAULT NULL |
| `hash_pipeline` | char(64) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_audit`),
KEY `idx_ref` (`id_referencia_externa`),
KEY `idx_hash` (`hash_pipeline`)
/*!40000 ALTER TABLE `estoque_audit_stream` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque_audit_stream` ENABLE KEYS */;
