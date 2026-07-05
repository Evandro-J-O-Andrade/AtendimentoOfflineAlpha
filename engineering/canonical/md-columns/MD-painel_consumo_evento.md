# MD-painel_consumo_evento-colunas — Colunas

## Tabela: `painel_consumo_evento`

### Campos

| Campo | Tipo | Constraint |
|-------|------|------------|
| `id_consumo` | bigint | NOT NULL AUTO_INCREMENT |
| `origem` | enum('SENHA_EVENTOS','FILA_OPERACIONAL_EVENTO') | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_evento` | bigint | NOT NULL |
| `painel_tipo` | varchar(50) | CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL |
| `id_local_operacional` | bigint | DEFAULT NULL |
| `consumido_em` | datetime | NOT NULL DEFAULT CURRENT_TIMESTAMP |
| `id_entidade` | bigint | unsigned NOT NULL |

---

## Índices

PRIMARY KEY (`id_consumo`),
UNIQUE KEY `uk_painel_consumo` (`origem`,`id_evento`,`painel_tipo`),
KEY `idx_painel_local` (`id_local_operacional`,`consumido_em`)
/*!40000 ALTER TABLE `painel_consumo_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `painel_consumo_evento` ENABLE KEYS */;
