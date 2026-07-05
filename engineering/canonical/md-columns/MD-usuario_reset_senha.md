# MD-usuario_reset_senha-colunas — Colunas

## Tabela: `usuario_reset_senha`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_reset` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `token_hash` | varchar(255) | NOT NULL |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `expira_em` | datetime | NOT NULL |
| `usado_em` | datetime | DEFAULT NULL |
| `ip_solicitacao` | varchar(45) | DEFAULT NULL |
| `user_agent` | varchar(255) | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_reset`),
KEY `ix_urs_usuario` (`id_usuario`),
KEY `ix_urs_expira` (`expira_em`),
KEY `ix_urs_token` (`token_hash`),
CONSTRAINT `fk_urs_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `usuario_reset_senha` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_reset_senha` ENABLE KEYS */;
