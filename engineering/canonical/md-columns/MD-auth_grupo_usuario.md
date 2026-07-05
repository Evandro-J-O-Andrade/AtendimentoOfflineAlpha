# MD-auth_grupo_usuario-colunas — Colunas

## Tabela: `auth_grupo_usuario`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_grupo_usuario` | bigint | NOT NULL AUTO_INCREMENT |
| `id_grupo` | bigint | NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `papel` | enum('MEMBRO','COORDENADOR','SUBCOORDENADOR') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'MEMBRO' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_grupo_usuario`),
UNIQUE KEY `uk_grupo_usuario` (`id_grupo`,`id_usuario`),
KEY `idx_grupo_usuario_usuario` (`id_usuario`),
CONSTRAINT `fk_gu_grupo` FOREIGN KEY (`id_grupo`) REFERENCES `auth_grupo` (`id_grupo`) ON DELETE CASCADE,
CONSTRAINT `fk_gu_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_grupo_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_grupo_usuario` ENABLE KEYS */;
