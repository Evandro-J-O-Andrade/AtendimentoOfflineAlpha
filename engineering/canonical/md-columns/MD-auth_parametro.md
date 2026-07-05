# MD-auth_parametro-colunas — Colunas

## Tabela: `auth_parametro`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_parametro` | bigint | NOT NULL AUTO_INCREMENT |
| `chave` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `valor` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci |
| `tipo_parametro` | enum('SENHA','SESSAO','TOKEN','BLOQUEIO','GERAL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'GERAL' |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_parametro`),
UNIQUE KEY `uk_parametro_chave` (`chave`)
/*!40000 ALTER TABLE `auth_parametro` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_parametro` ENABLE KEYS */;
