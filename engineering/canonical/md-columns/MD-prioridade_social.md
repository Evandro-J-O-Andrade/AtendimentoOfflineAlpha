# MD-prioridade_social-colunas — Colunas

## Tabela: `prioridade_social`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `peso` | int | NOT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id`),
UNIQUE KEY `codigo` (`codigo`)
/*!40000 ALTER TABLE `prioridade_social` DISABLE KEYS */;
/*!40000 ALTER TABLE `prioridade_social` ENABLE KEYS */;
