# MD-usuario_unidade-colunas — Colunas

## Tabela: `usuario_unidade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_unidade` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_unidade` | bigint | unsigned NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_unidade`),
UNIQUE KEY `uk_usuario_unidade` (`id_usuario`,`id_unidade`),
KEY `fk_uu_usuario` (`id_usuario`),
KEY `fk_uu_unidade` (`id_unidade`),
KEY `idx_usuario_entidade` (`id_usuario`,`id_entidade`),
KEY `fk_usuario_unidade_entidade` (`id_entidade`),
CONSTRAINT `fk_usuario_unidade_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`),
CONSTRAINT `fk_usuario_unidade_unidade` FOREIGN KEY (`id_unidade`) REFERENCES `unidade` (`id_unidade`),
CONSTRAINT `fk_uu_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `usuario_unidade` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_unidade` ENABLE KEYS */;
