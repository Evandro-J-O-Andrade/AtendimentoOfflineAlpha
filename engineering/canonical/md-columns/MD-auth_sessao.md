# MD-auth_sessao-colunas — Colunas

## Tabela: `auth_sessao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_sessao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `id_perfil` | bigint | DEFAULT NULL |
| `token_sessao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `user_agent` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `dispositivo` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `geo_localizacao` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `expira_em` | datetime | NOT NULL |
| `ultima_atividade` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_sessao`),
KEY `idx_sessao_usuario` (`id_usuario`),
KEY `idx_sessao_token` (`token_sessao`),
KEY `idx_sessao_expira` (`expira_em`),
CONSTRAINT `fk_sessao_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_sessao` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_sessao` ENABLE KEYS */;
