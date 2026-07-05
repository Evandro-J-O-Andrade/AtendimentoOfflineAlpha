# MD-caixa_evento-colunas — Colunas

## Tabela: `caixa_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_caixa` | bigint | NOT NULL |
| `tipo` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_ce_caixa` (`id_caixa`,`criado_em`)
/*!40000 ALTER TABLE `caixa_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `caixa_evento` ENABLE KEYS */;
