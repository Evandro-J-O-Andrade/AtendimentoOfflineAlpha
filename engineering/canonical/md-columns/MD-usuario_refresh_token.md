# MD-usuario_refresh_token-colunas — Colunas

## Tabela: `usuario_refresh_token`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_token` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `token` | varchar(255) | NOT NULL |
| `expira_em` | datetime | NOT NULL |
| `revogado` | tinyint(1) | DEFAULT '0' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_token`),
UNIQUE KEY `uk_refresh_token` (`token`),
KEY `idx_rt_usuario` (`id_usuario`),
CONSTRAINT `fk_rt_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `usuario_refresh_token` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_refresh_token` ENABLE KEYS */;
