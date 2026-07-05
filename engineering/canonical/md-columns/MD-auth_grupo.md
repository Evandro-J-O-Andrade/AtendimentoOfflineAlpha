# MD-auth_grupo-colunas — Colunas

## Tabela: `auth_grupo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_grupo` | bigint | NOT NULL AUTO_INCREMENT |
| `nome` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `tipo_grupo` | enum('SETOR','EQUIPE','PROJETO','REGIONAL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'SETOR' |
| `id_unidade` | bigint | unsigned NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `criado_por` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_grupo`),
KEY `idx_grupo_unidade` (`id_unidade`)
/*!40000 ALTER TABLE `auth_grupo` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_grupo` ENABLE KEYS */;
