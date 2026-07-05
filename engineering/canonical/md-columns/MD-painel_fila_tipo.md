# MD-painel_fila_tipo-colunas — Colunas

## Tabela: `painel_fila_tipo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_painel` | bigint | NOT NULL |
| `tipo_fila` | varchar(30) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_painel`,`tipo_fila`),
CONSTRAINT `fk_painel_fila_tipo_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `painel_fila_tipo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_fila_tipo` ENABLE KEYS */;
