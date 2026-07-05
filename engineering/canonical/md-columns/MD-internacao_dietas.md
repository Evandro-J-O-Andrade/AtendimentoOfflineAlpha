# MD-internacao_dietas-colunas — Colunas

## Tabela: `internacao_dietas`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_prescricao_item` | bigint | NOT NULL |
| `consistencia` | enum('LIVRE','BRANDAS','PASTOSA','LIQUIDA','ZERO','ENTERAL','PARENTERAL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `restricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `volume_total_dia` | int | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_dieta_presc` (`id_prescricao_item`),
CONSTRAINT `fk_dieta_presc` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_itens` (`id`)
/*!40000 ALTER TABLE `internacao_dietas` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_dietas` ENABLE KEYS */;
