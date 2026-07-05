# MD-prescricao_kit_master-colunas — Colunas

## Tabela: `prescricao_kit_master`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `nome_kit` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `descricao` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `ativo` | tinyint(1) | DEFAULT '1' |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `prescricao_kit_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `prescricao_kit_master` ENABLE KEYS */;
