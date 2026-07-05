# MD-auditoria_acesso-colunas — Colunas

## Tabela: `auditoria_acesso`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_auditoria_acesso` | bigint | NOT NULL AUTO_INCREMENT |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `recurso` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `acao` | enum('READ','SEARCH','EXPORT','PRINT','DOWNLOAD','VIEW') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'READ' |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `ip` | varchar(60) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `user_agent` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_auditoria_acesso`),
KEY `idx_aud_acesso_sessao` (`id_sessao_usuario`),
KEY `idx_aud_acesso_usuario` (`id_usuario`),
KEY `idx_aud_acesso_recurso` (`recurso`),
KEY `idx_aud_acesso_data` (`criado_em`),
CONSTRAINT `fk_aud_acesso_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`)
/*!40000 ALTER TABLE `auditoria_acesso` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_acesso` ENABLE KEYS */;
