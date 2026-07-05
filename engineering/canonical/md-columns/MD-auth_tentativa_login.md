# MD-auth_tentativa_login-colunas — Colunas

## Tabela: `auth_tentativa_login`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_tentativa` | bigint | NOT NULL AUTO_INCREMENT |
| `login` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `user_agent` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `sucesso` | tinyint(1) | NOT NULL DEFAULT '0' |
| `motivo_falha` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_tentativa`),
KEY `idx_tentativa_login` (`login`),
KEY `idx_tentativa_ip` (`ip_origem`),
KEY `idx_tentativa_data` (`criado_em`)
/*!40000 ALTER TABLE `auth_tentativa_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_tentativa_login` ENABLE KEYS */;
