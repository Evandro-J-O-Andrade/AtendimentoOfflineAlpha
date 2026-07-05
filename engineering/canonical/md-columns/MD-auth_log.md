# MD-auth_log-colunas — Colunas

## Tabela: `auth_log`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_log` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | DEFAULT NULL |
| `tipo_evento` | enum('LOGIN_SUCESSO','LOGIN_FALHA','LOGOUT','SENHA_TROCA','SENHA_RESET','TOKEN_REFRESH','BLOQUEIO','DESBLOQUEIO','SESSAO_EXPIRADA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `user_agent` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `dispositivo` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `localizacao` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `mensagem` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `dados_extras` | json | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_log`),
KEY `idx_log_usuario` (`id_usuario`),
KEY `idx_log_tipo` (`tipo_evento`),
KEY `idx_log_data` (`criado_em`)
/*!40000 ALTER TABLE `auth_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_log` ENABLE KEYS */;
