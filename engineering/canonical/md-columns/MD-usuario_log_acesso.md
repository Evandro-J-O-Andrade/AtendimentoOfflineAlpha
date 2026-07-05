# MD-usuario_log_acesso-colunas — Colunas

## Tabela: `usuario_log_acesso`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_log` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |
| `ip` | varchar(45) | NOT NULL |
| `user_agent` | varchar(255) | DEFAULT NULL |
| `sucesso` | tinyint(1) | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |

---

## Índices

PRIMARY KEY (`id_log`),
KEY `idx_log_usuario` (`id_usuario`),
KEY `idx_log_entidade` (`id_entidade`),
CONSTRAINT `fk_log_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_usuario_log_acesso_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `usuario_log_acesso` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_log_acesso` ENABLE KEYS */;
