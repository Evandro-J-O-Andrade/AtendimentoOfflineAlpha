# MD-prescricao_kit_itens-colunas — Colunas

## Tabela: `prescricao_kit_itens`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_kit` | int | NOT NULL |
| `item_nome` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `dose` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `via` | varchar(20) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `frequencia` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_kit_master_link` (`id_kit`),
CONSTRAINT `fk_kit_master_link` FOREIGN KEY (`id_kit`) REFERENCES `prescricao_kit_master` (`id`)
/*!40000 ALTER TABLE `prescricao_kit_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_kit_itens` ENABLE KEYS */;
