# MD-exame-colunas — Colunas

## Tabela: `exame`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_exame` | int | NOT NULL AUTO_INCREMENT |
| `codigo` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tipo` | enum('LAB','RX','OUTROS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_exame`),
UNIQUE KEY `codigo` (`codigo`)
/*!40000 ALTER TABLE `exame` DISABLE KEYS */;
/*!40000 ALTER TABLE `exame` ENABLE KEYS */;
