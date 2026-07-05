# MD-auth_audit-colunas — Colunas

## Tabela: `auth_audit`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_audit` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_sessao` | bigint | DEFAULT NULL |
| `acao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `recurso` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `detalhes` | json | DEFAULT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL |
| `user_agent` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `sucesso` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_audit`),
KEY `idx_audit_usuario` (`id_usuario`),
KEY `idx_audit_sessao` (`id_sessao`),
KEY `idx_audit_acao` (`acao`),
KEY `idx_audit_data` (`criado_em`)
/*!40000 ALTER TABLE `auth_audit` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_audit` ENABLE KEYS */;
