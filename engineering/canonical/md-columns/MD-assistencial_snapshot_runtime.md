# MD-assistencial_snapshot_runtime-colunas — Colunas

## Tabela: `assistencial_snapshot_runtime`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_snapshot` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `estado_runtime` | varchar(60) | DEFAULT NULL |
| `hash_estado` | char(64) | DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_snapshot`),
UNIQUE KEY `uk_snapshot_ffa` (`id_ffa`),
KEY `fk_assistencial_snapshot_runtime_atendimento` (`id_atendimento`),
KEY `idx_asr_ent` (`id_entidade`),
CONSTRAINT `fk_assistencial_snapshot_runtime_atendimento` FOREIGN KEY (`id_atendimento`) REFERENCES `atendimento` (`id_atendimento`) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT `fk_assistencial_snapshot_runtime_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `assistencial_snapshot_runtime` DISABLE KEYS */;
/*!40000 ALTER TABLE `assistencial_snapshot_runtime` ENABLE KEYS */;
