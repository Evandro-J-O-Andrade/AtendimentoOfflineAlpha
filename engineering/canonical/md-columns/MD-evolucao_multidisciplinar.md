# MD-evolucao_multidisciplinar-colunas — Colunas

## Tabela: `evolucao_multidisciplinar`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_evolucao` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | unsigned NOT NULL |
| `area` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_usuario` | bigint | NOT NULL |
| `data_hora` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_evolucao`),
KEY `id_atendimento` (`id_atendimento`),
KEY `id_usuario` (`id_usuario`),
CONSTRAINT `evolucao_multidisciplinar_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
/*!40000 ALTER TABLE `evolucao_multidisciplinar` DISABLE KEYS */;
/*!40000 ALTER TABLE `evolucao_multidisciplinar` ENABLE KEYS */;
