# MD-usuario_sistema-colunas — Colunas

## Tabela: `usuario_sistema`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario_sistema` | bigint | NOT NULL AUTO_INCREMENT |
| `id_usuario` | bigint | NOT NULL |
| `id_sistema` | bigint | NOT NULL |
| `id_perfil` | bigint | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime(6) | DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario_sistema`),
UNIQUE KEY `uk_usuario_sistema` (`id_usuario`,`id_sistema`),
KEY `idx_us_usuario` (`id_usuario`),
KEY `idx_us_sistema` (`id_sistema`),
KEY `fk_us_perfil` (`id_perfil`),
CONSTRAINT `fk_us_perfil` FOREIGN KEY (`id_perfil`) REFERENCES `perfil` (`id_perfil`),
CONSTRAINT `fk_us_sistema` FOREIGN KEY (`id_sistema`) REFERENCES `sistema` (`id_sistema`),
CONSTRAINT `fk_us_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `usuario_sistema` DISABLE KEYS */;
/*!40000 ALTER TABLE `usuario_sistema` ENABLE KEYS */;
