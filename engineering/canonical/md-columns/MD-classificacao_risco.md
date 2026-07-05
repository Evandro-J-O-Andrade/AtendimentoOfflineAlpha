# MD-classificacao_risco-colunas — Colunas

## Tabela: `classificacao_risco`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_risco` | int | NOT NULL AUTO_INCREMENT |
| `cor` | enum('VERMELHO','LARANJA','AMARELO','VERDE','AZUL') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `tempo_max` | int | DEFAULT NULL |
| `descricao` | varchar(100) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `id_entidade` | bigint | unsigned DEFAULT NULL |

---

## Índices

PRIMARY KEY (`id_risco`)
/*!40000 ALTER TABLE `classificacao_risco` DISABLE KEYS */;
/*!40000 ALTER TABLE `classificacao_risco` ENABLE KEYS */;
