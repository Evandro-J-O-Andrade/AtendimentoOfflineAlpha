# MD-runtime_evento_provisional-colunas — Colunas

## Tabela: `runtime_evento_provisional`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_provisional` | bigint | NOT NULL AUTO_INCREMENT |
| `uuid_evento` | char(36) | NOT NULL |
| `dominio_fluxo` | varchar(50) | NOT NULL |
| `payload_operacional` | json | NOT NULL |
| `hash_snapshot` | char(64) | NOT NULL |
| `token_execucao` | char(36) | NOT NULL |
| `versao_estado` | bigint | NOT NULL |
| `status_provisional` | enum('LOCAL_EXECUTADO','AGUARDANDO_SYNC','SINCRONIZADO','REJEITADO_CENTRAL') | DEFAULT 'LOCAL_EXECUTADO' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `sincronizado_em` | datetime(6) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_provisional`),
UNIQUE KEY `uk_provisional_uuid` (`uuid_evento`),
KEY `idx_provisional_status` (`status_provisional`),
KEY `idx_provisional_sync` (`sincronizado_em`)
/*!40000 ALTER TABLE `runtime_evento_provisional` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_evento_provisional` ENABLE KEYS */;
