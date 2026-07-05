# MD-farmacia_dispensacao_log-colunas — Colunas

## Tabela: `farmacia_dispensacao_log`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_prescricao_item` | bigint | NOT NULL |
| `id_sessao_usuario` | bigint | NOT NULL |
| `id_lote` | bigint | DEFAULT NULL |
| `quantidade` | decimal(14,3) | NOT NULL |
| `criado_em` | datetime(6) | NOT NULL DEFAULT CURRENT_TIMESTAMP(6) |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `idx_prescricao_item` (`id_prescricao_item`),
KEY `idx_sessao_usuario` (`id_sessao_usuario`),
KEY `idx_criado_em` (`criado_em`),
KEY `fk_fdl_lote` (`id_lote`),
CONSTRAINT `fk_fdl_lote` FOREIGN KEY (`id_lote`) REFERENCES `lote` (`id`) ON DELETE SET NULL,
CONSTRAINT `fk_fdl_prescricao_item` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_item` (`id_item`) ON DELETE CASCADE,
CONSTRAINT `fk_fdl_sessao` FOREIGN KEY (`id_sessao_usuario`) REFERENCES `sessao_usuario` (`id_sessao_usuario`) ON DELETE CASCADE
/*!40000 ALTER TABLE `farmacia_dispensacao_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `farmacia_dispensacao_log` ENABLE KEYS */;
