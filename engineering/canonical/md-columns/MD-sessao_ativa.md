# MD-sessao_ativa-colunas — Colunas

## Tabela: `sessao_ativa`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_usuario` | bigint | NOT NULL |
| `token_sessao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `ip_origem` | varchar(45) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ultimo_clique` | datetime | DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_usuario`),
UNIQUE KEY `uk_token` (`token_sessao`)
/*!40000 ALTER TABLE `sessao_ativa` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessao_ativa` ENABLE KEYS */;
