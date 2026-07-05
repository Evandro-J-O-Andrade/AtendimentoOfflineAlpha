# MD-usuario_local-colunas — Colunas

## Tabela: `usuario_local`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_local` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_local` | bigint | NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_local`),
UNIQUE KEY `uk_usuario_local` (`id_usuario`,`id_local`),
KEY `idx_ul_usuario` (`id_usuario`),
KEY `idx_ul_local` (`id_local`),
KEY `fk_usuario_local_entidade` (`id_entidade`),
CONSTRAINT `fk_ul_local` FOREIGN KEY (`id_local`) REFERENCES `local` (`id_local`),
CONSTRAINT `fk_ul_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`),
CONSTRAINT `fk_usuario_local_entidade` FOREIGN KEY (`id_entidade`) REFERENCES `saas_entidade` (`id_entidade`)
/*!40000 ALTER TABLE `usuario_local` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_local` ENABLE KEYS */;
