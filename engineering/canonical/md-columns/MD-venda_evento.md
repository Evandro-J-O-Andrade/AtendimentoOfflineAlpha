# MD-venda_evento-colunas — Colunas

## Tabela: `venda_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evento` | bigint | NOT NULL AUTO_INCREMENT |
| `id_venda` | bigint | NOT NULL |
| `tipo` | varchar(40) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `criado_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_usuario` | bigint | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evento`),
KEY `idx_ve_venda` (`id_venda`,`criado_em`)
/*!40000 ALTER TABLE `venda_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `venda_evento` ENABLE KEYS */;
