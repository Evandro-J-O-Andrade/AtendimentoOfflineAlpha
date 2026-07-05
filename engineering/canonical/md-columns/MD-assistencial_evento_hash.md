# MD-assistencial_evento_hash-colunas — Colunas

## Tabela: `assistencial_evento_hash`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_hash` | bigint | NOT NULL AUTO_INCREMENT |
| `hash_fingerprint` | char(64) | NOT NULL |
| `id_ffa` | bigint | NOT NULL |
| `evento` | varchar(60) | NOT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_hash`),
UNIQUE KEY `uk_assistencial_hash_fingerprint` (`hash_fingerprint`),
KEY `idx_assistencial_hash_lookup` (`id_ffa`,`evento`)
/*!40000 ALTER TABLE `assistencial_evento_hash` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_evento_hash` ENABLE KEYS */;
