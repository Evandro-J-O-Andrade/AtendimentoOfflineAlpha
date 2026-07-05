# MD-auditoria_estoque-colunas — Colunas

## Tabela: `auditoria_estoque`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_log` | bigint | NOT NULL AUTO_INCREMENT |
| `id_produto` | bigint | NOT NULL |
| `id_local` | int | NOT NULL |
| `acao` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `quantidade` | int | NOT NULL |
| `id_usuario` | bigint | DEFAULT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_log`)
/*!40000 ALTER TABLE `auditoria_estoque` DISABLE KEYS */;
/*!40000 ALTER TABLE `auditoria_estoque` ENABLE KEYS */;
