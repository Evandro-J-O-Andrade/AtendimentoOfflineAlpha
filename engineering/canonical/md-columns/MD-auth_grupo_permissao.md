# MD-auth_grupo_permissao-colunas — Colunas

## Tabela: `auth_grupo_permissao`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_grupo_permissao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_grupo` | bigint | NOT NULL |
| `recurso` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `acao` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_grupo_permissao`),
UNIQUE KEY `uk_grupo_recurso` (`id_grupo`,`recurso`,`acao`),
CONSTRAINT `fk_gp_grupo` FOREIGN KEY (`id_grupo`) REFERENCES `auth_grupo` (`id_grupo`) ON DELETE CASCADE
/*!40000 ALTER TABLE `auth_grupo_permissao` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_grupo_permissao` ENABLE KEYS */;
