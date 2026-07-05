# MD-usuario_senha_reset-colunas — Colunas

## Tabela: `usuario_senha_reset`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_senha_reset` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `token_hash` | varchar(64) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `expira_em` | datetime | NOT NULL |
| `usado_em` | datetime | DEFAULT NULL |
| `id_sessao_usuario_solicitante` | bigint | DEFAULT NULL |
| `id_usuario_solicitante` | bigint | DEFAULT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_senha_reset`),
UNIQUE KEY `ux_usr_reset_token_hash` (`token_hash`),
KEY `idx_usr_reset_usuario` (`id_usuario`),
KEY `idx_usr_reset_expira` (`expira_em`),
KEY `fk_usr_reset_sessao` (`id_sessao_usuario_solicitante`),
KEY `fk_usr_reset_solicitante` (`id_usuario_solicitante`),
CONSTRAINT `fk_usr_reset_solicitante` FOREIGN KEY (`id_usuario_solicitante`) REFERENCES `usuario` (`id_usuario`) ON DELETE SET NULL,
CONSTRAINT `fk_usr_reset_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `usuario_senha_reset` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_senha_reset` ENABLE KEYS */;
