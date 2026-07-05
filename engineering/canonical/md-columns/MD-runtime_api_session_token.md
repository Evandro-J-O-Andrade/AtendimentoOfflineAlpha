# MD-runtime_api_session_token-colunas — Colunas

## Tabela: `runtime_api_session_token`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_token` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `uuid_runtime` | varchar(36) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `token_hash` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `expira_em` | datetime | NOT NULL |
| `device_id` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `tenant_id` | bigint | DEFAULT '1' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `ultimo_acesso` | datetime | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_token`),
UNIQUE KEY `uk_uuid_runtime` (`uuid_runtime`),
KEY `idx_token_hash` (`token_hash`),
KEY `idx_id_usuario` (`id_usuario`),
KEY `idx_expira` (`expira_em`)
/*!40000 ALTER TABLE `runtime_api_session_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `runtime_api_session_token` ENABLE KEYS */;
