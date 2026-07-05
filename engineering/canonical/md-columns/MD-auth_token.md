# MD-auth_token-colunas — Colunas

## Tabela: `auth_token`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_token` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `tipo_token` | enum('ACCESS','REFRESH','RECOVERY','VERIFICATION') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `token_hash` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `user_agent` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `expira_em` | datetime | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `utilizado_em` | datetime | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_token`),
KEY `idx_token_usuario` (`id_usuario`),
KEY `idx_token_hash` (`token_hash`),
KEY `idx_token_expira` (`expira_em`),
CONSTRAINT `fk_token_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_token` ENABLE KEYS */;
