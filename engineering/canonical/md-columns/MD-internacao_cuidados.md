# MD-internacao_cuidados-colunas — Colunas

## Tabela: `internacao_cuidados`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_prescricao_item` | bigint | NOT NULL |
| `tipo_cuidado` | enum('DECUBITO','CURATIVO','DRENO','SONDA','OXIGENIO','SINAIS_VITAIS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `posicionamento` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `frequencia_checagem` | int | DEFAULT NULL |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`),
KEY `fk_cuidado_presc` (`id_prescricao_item`),
CONSTRAINT `fk_cuidado_presc` FOREIGN KEY (`id_prescricao_item`) REFERENCES `prescricao_itens` (`id`)
/*!40000 ALTER TABLE `internacao_cuidados` DISABLE KEYS */;
/*!40000 ALTER TABLE `internacao_cuidados` ENABLE KEYS */;
