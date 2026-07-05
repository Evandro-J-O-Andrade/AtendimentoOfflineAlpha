# MD-painel_grupo-colunas — Colunas

## Tabela: `painel_grupo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_grupo` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `nome` | varchar(120) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | NOT NULL DEFAULT '1' |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_grupo`),
UNIQUE KEY `uk_grupo_codigo` (`codigo`)
/*!40000 ALTER TABLE `painel_grupo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_grupo` ENABLE KEYS */;
