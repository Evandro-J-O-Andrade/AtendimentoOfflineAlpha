# MD-painel_alertas_tempo-colunas — Colunas

## Tabela: `painel_alertas_tempo`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id` | int | NOT NULL AUTO_INCREMENT |
| `id_senha` | bigint | DEFAULT NULL |
| `mensagem` | varchar(255) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `nivel` | enum('AVISO','CRITICO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL |
| `data_alerta` | datetime | DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id`)
/*!40000 ALTER TABLE `painel_alertas_tempo` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_alertas_tempo` ENABLE KEYS */;
