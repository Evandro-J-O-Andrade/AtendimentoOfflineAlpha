# MD-runtime_invariant_log-colunas — Colunas

## Tabela: `runtime_invariant_log`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_invariant` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_runtime` | char(36) | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `tipo_invariante` | varchar(80) | NOT NULL |
| `payload_original` | json | DEFAULT NULL |
| `hash_payload` | char(64) | NOT NULL |
| `estado_valido` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_invariant`),
KEY `idx_invariant_uuid` (`uuid_runtime`),
KEY `idx_invariant_estado` (`estado_valido`),
KEY `fk_runtime_invariant_log_unidade` (`id_unidade`),
KEY `fk_runtime_invariant_log_entidade` (`id_entidade`),
CONSTRAINT `fk_runtime_invariant_log_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_runtime_invariant_log_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`)
/*!40000 ALTER TABLE `runtime_invariant_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_invariant_log` ENABLE KEYS */;
