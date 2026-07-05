# MD-painel_lane-colunas — Colunas

## Tabela: `painel_lane`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_painel` | bigint | NOT NULL |
| `lane` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_painel`,`lane`),
CONSTRAINT `fk_painel_lane_painel` FOREIGN KEY (`id_painel`) REFERENCES `painel` (`id_painel`)
/*!40000 ALTER TABLE `painel_lane` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_lane` ENABLE KEYS */;
