# MD-transporte_ambulancia_evento-colunas — Colunas

## Tabela: `transporte_ambulancia_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_transporte` | bigint | NOT NULL |
| `evento` | varchar(80) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `detalhe` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_sessao_usuario` | bigint | DEFAULT NULL |
| `criado_em` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_tae_transporte` (`id_transporte`),
KEY `idx_tae_sessao` (`id_sessao_usuario`),
CONSTRAINT `fk_tae_transporte` FOREIGN KEY (`id_transporte`) REFERENCES `transporte_ambulancia` (`id`) ON DELETE CASCADE
/*!40000 ALTER TABLE `transporte_ambulancia_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `transporte_ambulancia_evento` ENABLE KEYS */;
