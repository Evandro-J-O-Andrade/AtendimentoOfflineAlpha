# MD-usuario_refresh-colunas — Colunas

## Tabela: `usuario_refresh`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_refresh` | bigint | NOT NULL AUTO_INCREMENT COMMENT 'ID do refresh token' |
| `id_usuario` | bigint | NOT NULL COMMENT 'Usuário dono do token' |
| `token_hash` | char(64) | NOT NULL COMMENT 'Hash do refresh token' |
| `expires_at` | datetime | NOT NULL COMMENT 'Expiração do token' |
| `created_at` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação' |
| `revoked` | tinyint(1) | NOT NULL DEFAULT '0' COMMENT 'Token revogado' |
| `user_agent` | varchar(255) | DEFAULT NULL COMMENT 'User agent do dispositivo' |
| `ip` | varchar(45) | DEFAULT NULL COMMENT 'IP de origem' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_refresh`),
UNIQUE KEY `uk_token_hash` (`token_hash`),
KEY `idx_usuario` (`id_usuario`),
CONSTRAINT `fk_usuario_refresh_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `usuario_refresh` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_refresh` ENABLE KEYS */;
