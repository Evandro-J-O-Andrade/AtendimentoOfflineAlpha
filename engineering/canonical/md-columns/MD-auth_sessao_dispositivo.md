# MD-auth_sessao_dispositivo-colunas — Colunas

## Tabela: `auth_sessao_dispositivo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_dispositivo_confiavel` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `dispositivo_hash` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `nome_dispositivo` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `sistema_operacional` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `navegador` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `ultimo_ip` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `ultimo_acesso` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `primeiro_acesso` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `confiavel` | tinyint(1) | DEFAULT '0' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_dispositivo_confiavel`),
KEY `idx_dispositivo_usuario` (`id_usuario`),
KEY `idx_dispositivo_hash` (`dispositivo_hash`),
CONSTRAINT `fk_dispositivo_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_sessao_dispositivo` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_sessao_dispositivo` ENABLE KEYS */;
