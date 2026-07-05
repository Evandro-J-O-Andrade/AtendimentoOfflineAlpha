# MD-kernel_identity_trust_chain-colunas — Colunas

## Tabela: `kernel_identity_trust_chain`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_chain` | bigint | NOT NULL AUTO_INCREMENT |
| `id_tenant` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `id_sessao` | bigint | DEFAULT NULL |
| `id_dispositivo` | bigint | DEFAULT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `user_agent` | varchar(500) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `fingerprint_runtime` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `fingerprint_behavior` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `fingerprint_device` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `estado_runtime` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `score_risco` | int | DEFAULT '0' |
| `limite_risco` | int | DEFAULT '80' |
| `tentativas` | int | DEFAULT '0' |
| `janela_tentativa` | int | DEFAULT '15' |
| `nonce_runtime` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `lineage_hash` | char(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `atualizado_em` | datetime(6) | DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_chain`),
UNIQUE KEY `uk_nonce_runtime` (`nonce_runtime`),
KEY `idx_runtime_fp` (`fingerprint_runtime`),
KEY `idx_behavior_fp` (`fingerprint_behavior`),
KEY `idx_device_fp` (`fingerprint_device`),
KEY `idx_usuario` (`id_usuario`),
KEY `idx_tenant_usuario` (`id_tenant`,`id_usuario`),
KEY `idx_sessao` (`id_sessao`),
KEY `idx_dispositivo` (`id_dispositivo`),
KEY `idx_bloqueio` (`bloqueado`,`ativo`),
KEY `idx_score` (`score_risco`)
/*!40000 ALTER TABLE `kernel_identity_trust_chain` DISABLE KEYS */;
/*!40000 ALTER TABLE `kernel_identity_trust_chain` ENABLE KEYS */;
