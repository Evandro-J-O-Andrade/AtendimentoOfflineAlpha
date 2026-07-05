# MD-auth_notificacao-colunas — Colunas

## Tabela: `auth_notificacao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_notificacao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `tipo_notificacao` | enum('LOGIN_NOVO_DISPOSITIVO','LOGIN_SUSPEITO','SENHA_EXPIRANDO','BLOQUUEIO_CONTA','SEGURANCA_ALERTA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `titulo` | varchar(200) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `mensagem` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `lido` | tinyint(1) | DEFAULT '0' |
| `lido_em` | datetime | DEFAULT NULL |
| `dados_extras` | json | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_notificacao`),
KEY `idx_notif_usuario` (`id_usuario`),
KEY `idx_notif_lido` (`lido`),
KEY `idx_notif_data` (`criado_em`),
CONSTRAINT `fk_notif_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_notificacao` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_notificacao` ENABLE KEYS */;
