# MD-runtime_estado_sobrevivencia-colunas — Colunas

## Tabela: `runtime_estado_sobrevivencia`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_estado` | bigint | NOT NULL AUTO_INCREMENT |
| `runtime_device_id` | varchar(100) | NOT NULL |
| `modo_operacao` | enum('NORMAL','DEGRADADO','OFFLINE_AUTONOMO','BLOQUEIO_SEGURANCA') | DEFAULT 'NORMAL' |
| `ultima_sincronizacao` | datetime(6) | DEFAULT NULL |
| `hash_snapshot_runtime` | char(64) | DEFAULT NULL |
| `evento_seguranca` | json | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_estado`),
UNIQUE KEY `uk_runtime_device` (`runtime_device_id`),
KEY `idx_runtime_modo` (`modo_operacao`)
/*!40000 ALTER TABLE `runtime_estado_sobrevivencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_estado_sobrevivencia` ENABLE KEYS */;
