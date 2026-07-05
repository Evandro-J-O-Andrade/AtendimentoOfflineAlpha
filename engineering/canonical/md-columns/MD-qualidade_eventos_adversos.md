# MD-qualidade_eventos_adversos-colunas — Colunas

## Tabela: `qualidade_eventos_adversos`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | bigint | NOT NULL AUTO_INCREMENT |
| `id_atendimento` | bigint | NOT NULL |
| `tipo_evento` | enum('QUEDA','ERRO_MEDICACAO','INFECCAO_SITIO','LESÃO_PRESSAO','OUTROS') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `gravidade` | enum('LEVE','MODERADA','GRAVE','SENTINELA') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `descricao` | text | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci |
| `data_evento` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `qualidade_eventos_adversos` DISABLE KEYS */;
/*!40000 ALTER TABLE `qualidade_eventos_adversos` ENABLE KEYS */;
