# MD-ffa_prioridade-colunas — Colunas

## Tabela: `ffa_prioridade`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_ffa` | bigint | NOT NULL |
| `codigo_prioridade` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `ffa_prioridade` DISABLE KEYS */;
/*!40000 ALTER TABLE `ffa_prioridade` ENABLE KEYS */;
