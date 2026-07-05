# MD-runtime_snapshot_metadata-colunas — Colunas

## Tabela: `runtime_snapshot_metadata`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_snapshot` | bigint | NOT NULL AUTO_INCREMENT |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `versao_fluxo` | bigint | NOT NULL |
| `hash_snapshot` | char(64) | NOT NULL |
| `payload_metadata` | json | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `expiracao_snapshot` | datetime(6) | NOT NULL |
| `ultima_validacao_runtime` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_snapshot`),
UNIQUE KEY `uk_snapshot_fluxo_hash` (`hash_snapshot`),
KEY `idx_snapshot_fluxo` (`dominio_fluxo`,`versao_fluxo`),
KEY `idx_snapshot_expiracao` (`expiracao_snapshot`)
/*!40000 ALTER TABLE `runtime_snapshot_metadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_snapshot_metadata` ENABLE KEYS */;
